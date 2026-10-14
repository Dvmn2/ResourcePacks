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

// p4 = split (lives in Params2.x). Verifies that parameters with index >= 4 reach the shader.
void main() {
    float o = Params2.x * Control.x;
    float r = texture(InSampler, texCoord + vec2(o, 0.0)).r;
    float g = texture(InSampler, texCoord).g;
    float b = texture(InSampler, texCoord - vec2(o, 0.0)).b;
    fragColor = vec4(r, g, b, 1.0);
}
