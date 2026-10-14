#version 330

uniform sampler2D InSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform EffectParams {
    vec4 Control;
    vec4 Color;
    vec4 Params;
    vec4 Params2;
};

in vec2 texCoord;
out vec4 fragColor;

void main() {
    // deliberate compile error (the ONLY defect in this pack): undeclared identifier
    fragColor = vec4(undefined_variable, Control.x, Params.x, 1.0);
}
