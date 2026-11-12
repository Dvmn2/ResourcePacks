#version 330

uniform sampler2D InSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform EffectParams {
    vec4 Control;   // x = intensity 0..1, y = time (s), w = seed
    vec4 Color;
    vec4 Params;    // p0..p3
    vec4 Params2;   // p4..p7
};

in vec2 texCoord;
out vec4 fragColor;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 3; i++) {
        v += a * noise(p);
        p *= 2.03;
        a *= 0.5;
    }
    return v / 0.875;
}

// Thin bright lines along the 0.5 iso-contour of fbm: a vein network.
float ridge(vec2 p) {
    return 1.0 - abs(2.0 * fbm(p) - 1.0);
}

// p0 = stage 0..4 (fractions allowed), p1 = pixel size, p2 = speed
// Color = sculk glow color. Pulse rate is capped below 3 Hz (safe for flashing filter).
void main() {
    float t = Control.y;
    float k = Control.x;
    float stage = clamp(Params.x, 0.0, 4.0);
    float pxs = clamp(Params.y, 2.0, 16.0);
    float speed = clamp(Params.z, 0.0, 1.5);
    float s01 = stage / 4.0;

    float heart = smoothstep(1.5, 3.0, stage);
    float rate = mix(0.6, 1.7, s01) * speed;
    float pulse = pow(max(sin(fract(t * rate) * 6.2831853), 0.0), 3.0);

    vec3 orig = texture(InSampler, texCoord).rgb;

    // --- stage 3+: wobble + chromatic aberration
    vec2 uv = texCoord;
    float wob = smoothstep(2.0, 4.0, stage) * 0.0025;
    uv += vec2(sin(uv.y * 18.0 + t * 1.3 * speed), cos(uv.x * 14.0 + t * 1.1 * speed)) * wob;
    float ca = smoothstep(1.5, 3.5, stage) * (0.002 + 0.003 * pulse * heart);
    vec3 c;
    c.r = texture(InSampler, uv + vec2(ca, 0.0)).r;
    c.g = texture(InSampler, uv).g;
    c.b = texture(InSampler, uv - vec2(ca, 0.0)).b;

    // --- color grading: desaturate, teal tint, darken
    float l = dot(c, vec3(0.299, 0.587, 0.114));
    c = mix(c, vec3(l), 0.55 * clamp(s01 * 1.4, 0.0, 1.0));
    float tint = clamp(s01 * 1.5, 0.0, 1.0);
    c *= mix(vec3(1.0), vec3(0.72, 0.95, 1.05), tint) * (1.0 - 0.3 * s01);

    // --- tunnel vision (stage 3-4)
    float d = length(texCoord - 0.5) * 1.4142;
    float inner = mix(1.15, 0.3, smoothstep(2.0, 4.0, stage));
    float vig = smoothstep(inner, inner + 0.55, d) * (0.85 + 0.15 * pulse * heart) * 0.9;
    c = mix(c, vec3(0.01, 0.035, 0.045), clamp(vig, 0.0, 1.0));

    // --- pixel grid (resolution independent)
    vec2 cell = floor(texCoord * InSize / pxs);
    vec2 cuv = (cell + 0.5) * pxs / InSize.y;
    vec2 sp = cuv + vec2(Control.w * 0.37);
    vec2 drift = vec2(t * 0.010, -t * 0.007) * speed;

    // --- infected region creeps from the screen edges inward
    float front = mix(1.05, -0.25, pow(s01, 0.8)) + 0.025 * sin(t * 1.7 * speed);
    float dp = d + (fbm(sp * 2.0) - 0.5) * 0.38;
    float inReg = step(front, dp) * step(0.01, stage);

    // --- dark sculk patches
    float pm = fbm(sp * 1.4 + 11.0);
    float pat = inReg * step(0.5, pm) * step(front + 0.04, dp);
    vec3 patchCol = mix(vec3(0.02, 0.06, 0.08), vec3(0.04, 0.11, 0.13), hash(cell));
    c = mix(c, patchCol, pat * (0.4 + 0.3 * s01));

    // --- veins (+ thinner branches from stage 1+)
    float w1 = 0.03 + 0.012 * stage;
    float w2 = w1 * 0.75 * smoothstep(1.0, 2.5, stage);
    float r1 = ridge((sp + drift) * 4.0);
    float r2 = ridge((sp - drift * 0.7) * 9.0 + 31.0);
    float line = max(step(1.0 - w1, r1), step(1.0 - w2, r2)) * inReg;
    float halo = max(step(1.0 - w1 * 2.6, r1), step(1.0 - w2 * 2.6, r2)) * inReg;
    vec3 vc = mix(Color.rgb, vec3(1.0), 0.2 * pulse) * (0.75 + 0.45 * pulse);
    c = mix(c, vc * 0.35, (halo - line) * 0.7);
    c = mix(c, vc, line);

    // --- bioluminescent specks (slow, <0.5 Hz each)
    float hs = hash(cell + 7.3);
    float dotOn = step(0.985 - 0.01 * s01, hs) * inReg;
    float phase = 0.5 + 0.5 * sin(t * (0.8 + hash(cell) * 1.2) * speed + hs * 40.0);
    c = mix(c, Color.rgb, dotOn * phase * 0.9);

    fragColor = vec4(mix(orig, c, clamp(k, 0.0, 1.0)), 1.0);
}
