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

// p0 = speed 0.1..1.5, p1 = ring width (default 0.08)
void main() {
    float t = Control.y;
    float k = Control.x;
    float speed = clamp(Params.x, 0.1, 1.5);
    float w = max(Params.y, 0.02);

    float cycle = fract(t * 0.35 * speed);
    vec2 dv = (texCoord - 0.5) * vec2(InSize.x / InSize.y, 1.0);
    float d = length(dv);
    float ring = exp(-pow((d - cycle * 1.3) / w, 2.0)) * (1.0 - cycle);
    vec2 dir = dv / max(d, 0.0001);

    vec3 orig = texture(InSampler, texCoord).rgb;
    vec3 c = texture(InSampler, texCoord - dir * ring * 0.02).rgb;
    c = mix(c, vec3(dot(c, vec3(0.299, 0.587, 0.114))), 0.35 * ring);
    c += Color.rgb * ring * 0.55;

    fragColor = vec4(mix(orig, c, clamp(k, 0.0, 1.0)), 1.0);
}
