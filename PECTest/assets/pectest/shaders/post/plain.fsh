#version 330

uniform sampler2D InSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

in vec2 texCoord;
out vec4 fragColor;

// No EffectParams block in the pass: nothing to write, intensity is ignored. Expect: inverted picture.
void main() {
    fragColor = vec4(1.0 - texture(InSampler, texCoord).rgb, 1.0);
}
