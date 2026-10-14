#version 330

uniform sampler2D InSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform EffectParams {
    vec4 Control;   // x = intensity 0..1, y = time (s), w = seed
    vec4 Color;     // rgb = color
    vec4 Params;    // p0..p3
    vec4 Params2;   // p4..p7
};

in vec2 texCoord;
out vec4 fragColor;

// p0 = amplitude, p1 = frequency. Horizontal sine distortion that moves with time.
void main() {
    vec2 uv = texCoord;
    uv.x += sin(uv.y * Params.y + Control.y * 2.0) * Params.x * Control.x;
    fragColor = vec4(texture(InSampler, uv).rgb, 1.0);
}
