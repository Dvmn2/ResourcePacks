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

// p0 = pulse Hz 0.5..2.5, p1 = radial blur 0..2
void main() {
    float t = Control.y;
    float k = Control.x;
    float rate = clamp(Params.x, 0.5, 2.5);
    float blur = clamp(Params.y, 0.0, 2.0);

    vec3 orig = texture(InSampler, texCoord).rgb;
    float pulse = pow(max(sin(fract(t * rate) * 6.2831853), 0.0), 2.0);

    vec2 dv = texCoord - 0.5;
    float d = length(dv) * 1.4142;
    vec2 uv = 0.5 + dv * (1.0 - 0.02 * pulse);

    // radial blur toward the center, stronger at the edges
    float str = blur * 0.03 * smoothstep(0.15, 1.0, d) * (0.7 + 0.3 * pulse);
    vec3 c = vec3(0.0);
    for (int i = 0; i < 7; i++) {
        float s = float(i) / 6.0;
        c += texture(InSampler, uv - (uv - 0.5) * str * s).rgb;
    }
    c /= 7.0;

    // saturation + contrast + warm tint
    float l = dot(c, vec3(0.299, 0.587, 0.114));
    c = mix(vec3(l), c, 1.35);
    c = (c - 0.5) * 1.12 + 0.5;
    c = mix(c, c * (Color.rgb * 1.1), 0.25);

    // tunnel focus
    float vig = smoothstep(0.55, 1.1, d) * (0.25 + 0.15 * pulse);
    c = mix(c, c * 0.35, vig);

    fragColor = vec4(mix(orig, max(c, 0.0), clamp(k, 0.0, 1.0)), 1.0);
}
