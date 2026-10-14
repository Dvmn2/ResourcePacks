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

// Flashing test; amplitude and frequency are capped in the meta file (max 0.4 / 3 Hz).
// With /pec noflash true this effect must NOT be drawn at all.
void main() {
    vec3 src = texture(InSampler, texCoord).rgb;
    float f = step(0.5, fract(Control.y * Params.y));
    fragColor = vec4(mix(src, Color.rgb, f * Params.x * Control.x), 1.0);
}
