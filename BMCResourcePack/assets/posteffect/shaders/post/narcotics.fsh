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

// p0 = trip 0..2, p1 = hue speed (turns/s) 0..0.3, p2 = wave 0..2
vec3 hueRot(vec3 c, float a) {
    vec3 ax = vec3(0.57735);
    float cs = cos(a);
    return c * cs + cross(ax, c) * sin(a) + ax * dot(ax, c) * (1.0 - cs);
}

void main() {
    float t = Control.y;
    float k = Control.x;
    float trip = clamp(Params.x, 0.0, 2.0);
    float hs = clamp(Params.y, 0.0, 0.3);
    float wave = clamp(Params.z, 0.0, 2.0);

    vec3 orig = texture(InSampler, texCoord).rgb;

    // warped, breathing picture
    vec2 uv = texCoord;
    vec2 w = vec2(fbm(uv * 3.0 + t * 0.15), fbm(uv * 3.0 + 17.0 - t * 0.12)) - 0.5;
    uv += w * 0.06 * trip * wave;
    uv += vec2(sin(uv.y * 10.0 + t * 0.9), cos(uv.x * 9.0 + t * 0.7)) * 0.006 * trip * wave;
    uv = 0.5 + (uv - 0.5) * (1.0 - 0.03 * trip * sin(t * 0.5));

    // color split + ghost images
    vec2 o = vec2(cos(t * 0.7), sin(t * 0.9)) * 0.01 * trip;
    vec3 split = vec3(texture(InSampler, uv + o).r,
                      texture(InSampler, uv).g,
                      texture(InSampler, uv - o).b);
    vec3 ghost = 0.5 * (texture(InSampler, uv + o * 2.5).rgb + texture(InSampler, uv - o * 2.5).rgb);
    vec3 c = mix(split, ghost, 0.4 * clamp(trip, 0.0, 1.0));

    // rotating hue with spatial variation, boosted saturation
    c = hueRot(c, t * hs * 6.2831853 + (fbm(uv * 2.0 + t * 0.05) - 0.5) * 2.0 * trip);
    float l = dot(c, vec3(0.299, 0.587, 0.114));
    c = mix(vec3(l), c, 1.0 + 0.6 * trip);

    // soft glow in the chosen color
    c += Color.rgb * 0.07 * trip * (0.5 + 0.5 * sin(t * 0.8));

    fragColor = vec4(mix(orig, clamp(c, 0.0, 1.0), clamp(k, 0.0, 1.0)), 1.0);
}
