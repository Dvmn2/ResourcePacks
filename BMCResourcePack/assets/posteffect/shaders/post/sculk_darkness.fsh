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

// p0 = pulse rate in Hz (0.1..1.5), p1 = depth 0..1
void main() {
    float t = Control.y;
    float k = Control.x;
    float rate = clamp(Params.x, 0.1, 1.5);
    float depth = clamp(Params.y, 0.0, 1.0);

    vec3 orig = texture(InSampler, texCoord).rgb;
    float wave = 0.5 + 0.5 * sin(t * rate * 6.2831853);
    float d = length(texCoord - 0.5) * 1.4142;
    float vig = smoothstep(0.35, 1.0, d);
    float amount = clamp(depth * (0.45 + 0.55 * wave) * (0.35 + 0.65 * vig), 0.0, 1.0);

    float l = dot(orig, vec3(0.299, 0.587, 0.114));
    vec3 c = mix(orig, vec3(l), 0.4 * amount);
    c = mix(c, Color.rgb * 0.04, amount);

    fragColor = vec4(mix(orig, c, clamp(k, 0.0, 1.0)), 1.0);
}
