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

float bump(float x, float c, float w) {
    float z = (x - c) / w;
    return exp(-z * z);
}

// "lub-dub" heartbeat envelope for ph in 0..1
float heartbeat(float ph) {
    return bump(ph, 0.04, 0.05) + 0.6 * bump(ph, 0.24, 0.06);
}

// p0 = severity 0..1, p1 = heartbeat Hz 0.3..1.5, p2 = pixel size
void main() {
    float t = Control.y;
    float k = Control.x;
    float sev = clamp(Params.x, 0.0, 1.0);
    float rate = clamp(Params.y, 0.3, 1.5);
    float pxs = clamp(Params.z, 2.0, 16.0);

    vec3 orig = texture(InSampler, texCoord).rgb;
    float b = heartbeat(fract(t * rate));

    // desaturate + red cast
    float l = dot(orig, vec3(0.299, 0.587, 0.114));
    vec3 c = mix(orig, vec3(l), 0.5 * sev);
    c *= mix(vec3(1.0), vec3(1.0, 0.78, 0.78), sev);

    // pulsing red vignette
    float d = length(texCoord - 0.5) * 1.4142;
    float inner = mix(1.0, 0.35, sev);
    float vig = smoothstep(inner, inner + 0.5, d) * (0.65 + 0.45 * b);
    c = mix(c, Color.rgb * 0.55, clamp(vig * 0.85, 0.0, 1.0));

    // pixel blood splatter creeping in from the edges
    vec2 cell = floor(texCoord * InSize / pxs);
    vec2 cuv = (cell + 0.5) * pxs / InSize.y;
    vec2 sp = cuv + vec2(Control.w * 0.37);
    float front = mix(1.05, 0.5, sev);
    float dp = d + (fbm(sp * 2.0) - 0.5) * 0.3;
    float blob = step(front, dp) * step(0.58 - 0.1 * sev, fbm(sp * 3.0 + 5.0)) * step(0.01, sev);
    vec3 bloodCol = mix(Color.rgb * 0.45, Color.rgb, hash(cell) * 0.8);
    c = mix(c, bloodCol, blob * 0.85);

    // drips running down from the top edge
    float cx = floor(texCoord.x * InSize.x / pxs * 0.5);
    float h = hash(vec2(cx, 1.0));
    float on = step(0.9 - 0.3 * sev, h);
    float len = sev * (0.08 + 0.4 * hash(vec2(cx, 2.0)));
    len *= 0.85 + 0.15 * sin(t * 0.3 + h * 6.2831853);
    float drip = on * step(1.0 - texCoord.y, len);
    c = mix(c, Color.rgb * (0.65 + 0.35 * hash(cell + 3.0)), drip * 0.9);

    fragColor = vec4(mix(orig, c, clamp(k, 0.0, 1.0)), 1.0);
}
