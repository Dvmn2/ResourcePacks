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

// p0 = phase 0..1 (0 = fibrillation, 1 = flatline), p1 = initial heartbeat Hz 0.3..1.5
void main() {
    float t = Control.y;
    float k = Control.x;
    float phase = clamp(Params.x, 0.0, 1.0);
    float rate = clamp(Params.y, 0.3, 1.5);

    vec3 orig = texture(InSampler, texCoord).rgb;

    // beats slow down, become irregular and finally vanish
    float tt = t * rate * (1.0 - 0.85 * phase) + 0.3 * sin(t * 1.7) + 0.15 * (1.0 - phase) * sin(t * 4.1);
    float b = heartbeat(fract(tt));
    float beatAmp = 1.0 - smoothstep(0.7, 1.0, phase);

    // blur grows with phase (6 taps on a circle)
    float rad = 0.004 + 0.012 * phase;
    vec3 c = texture(InSampler, texCoord).rgb;
    for (int i = 0; i < 6; i++) {
        float a = float(i) * 1.0471976;
        c += texture(InSampler, texCoord + vec2(cos(a), sin(a)) * rad * vec2(InSize.y / InSize.x, 1.0)).rgb;
    }
    c /= 7.0;

    // grayscale, flat contrast, red cast early on
    float l = dot(c, vec3(0.299, 0.587, 0.114));
    c = mix(c, vec3(l), clamp(phase * 1.5, 0.0, 1.0));
    c = mix(c, c * mix(vec3(1.0), Color.rgb * 1.6 + 0.2, 0.35), 1.0 - phase);

    // closing tunnel; each beat opens it a little
    float d = length(texCoord - 0.5) * 1.4142;
    float inner = mix(1.1, 0.02, smoothstep(0.1, 0.9, phase));
    float vig = smoothstep(inner, inner + 0.4, d);
    vig *= 1.0 - 0.35 * b * beatAmp;
    c = mix(c, vec3(0.0), clamp(vig, 0.0, 1.0));
    c *= (1.0 - 0.92 * smoothstep(0.6, 1.0, phase)) * (1.0 + 0.4 * b * beatAmp * (1.0 - phase));

    // flatline with a moving sweep head
    float lineA = smoothstep(0.7, 0.95, phase);
    float yy = abs(texCoord.y - 0.5) * InSize.y;
    float thick = max(1.0, InSize.y / 540.0);
    float sweep = fract(t * 0.25);
    float trail = exp(-fract(sweep - texCoord.x) * 3.0);
    vec3 lineCol = mix(Color.rgb, vec3(1.0), 0.45);
    c = mix(c, lineCol, step(yy, thick) * trail * lineA);

    fragColor = vec4(mix(orig, clamp(c, 0.0, 1.0), clamp(k, 0.0, 1.0)), 1.0);
}
