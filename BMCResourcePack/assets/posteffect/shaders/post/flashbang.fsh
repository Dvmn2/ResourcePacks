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

// p0 = decay time in seconds 0.5..15, p1 = blur 0..2
// Full white for 0.25 s, then fades. Use fade-in 0 so the flash is instant.
void main() {
    float t = Control.y;
    float k = Control.x;
    float decay = clamp(Params.x, 0.5, 15.0);
    float blur = clamp(Params.y, 0.0, 2.0);

    vec3 orig = texture(InSampler, texCoord).rgb;

    float hold = 0.25;
    float f = t < hold ? 1.0 : pow(max(1.0 - (t - hold) / decay, 0.0), 2.0);

    // blurry vision that clears up
    float rad = blur * 0.02 * f;
    vec2 asp = vec2(InSize.y / InSize.x, 1.0);
    vec3 c = orig;
    for (int i = 0; i < 8; i++) {
        float a = float(i) * 0.7853982;
        c += texture(InSampler, texCoord + vec2(cos(a), sin(a)) * rad * asp).rgb;
        c += texture(InSampler, texCoord + vec2(cos(a), sin(a)) * rad * 0.5 * asp).rgb;
    }
    c /= 17.0;

    float l = dot(c, vec3(0.299, 0.587, 0.114));
    c = mix(c, vec3(l), 0.6 * f);

    // dark afterimage blot in the middle of the view
    float dc = length((texCoord - 0.5) * vec2(InSize.x / InSize.y, 1.0));
    c = mix(c, vec3(0.12, 0.0, 0.18), smoothstep(0.25, 0.0, dc) * f * 0.55);

    // white-out
    c = mix(c, Color.rgb, clamp(f * 1.1, 0.0, 1.0));

    fragColor = vec4(mix(orig, c, clamp(k, 0.0, 1.0)), 1.0);
}
