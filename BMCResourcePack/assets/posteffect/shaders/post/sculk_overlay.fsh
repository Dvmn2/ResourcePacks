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

// Drawn over the HUD. p0 = reach 0..1, p1 = pixel size, p2 = flicker 0..1
// Fast electric flicker -> this effect is flagged "flashing".
void main() {
    float t = Control.y;
    float k = Control.x;
    float reach = clamp(Params.x, 0.0, 1.0);
    float pxs = clamp(Params.y, 2.0, 16.0);
    float flick = clamp(Params.z, 0.0, 1.0);

    vec3 c = texture(InSampler, texCoord).rgb;

    vec2 cell = floor(texCoord * InSize / pxs);
    vec2 cuv = (cell + 0.5) * pxs / InSize.y;
    vec2 sp = cuv + vec2(Control.w * 0.37);

    float d = length(texCoord - 0.5) * 1.4142;
    float front = mix(1.05, 0.45, reach) + 0.02 * sin(t * 1.9);
    float dp = d + (fbm(sp * 2.0) - 0.5) * 0.3;
    float inReg = step(front, dp) * step(0.01, reach);

    float w1 = 0.07;
    float r1 = ridge((sp + vec2(t * 0.012, -t * 0.008)) * 4.0);
    float r2 = ridge(sp * 9.0 + 31.0);
    float line = max(step(1.0 - w1, r1), step(1.0 - w1 * 0.7, r2)) * inReg;
    float halo = max(step(1.0 - w1 * 2.6, r1), step(1.0 - w1 * 1.8, r2)) * inReg;

    float fl = floor(t * 10.0);
    float band = step(0.75, hash(vec2(fl, floor(cuv.y * 6.0) + 3.0)));
    float surge = step(0.93, hash(vec2(fl, 9.0)));
    float bright = 1.0 - flick * 0.7 * band;
    vec3 vc = mix(Color.rgb, vec3(1.0), surge * flick * 0.7) * bright;

    c = mix(c, vc * 0.3, (halo - line) * 0.55);
    c = mix(c, vc, line * (1.0 - 0.35 * flick * band));

    fragColor = vec4(mix(texture(InSampler, texCoord).rgb, c, clamp(k, 0.0, 1.0)), 1.0);
}
