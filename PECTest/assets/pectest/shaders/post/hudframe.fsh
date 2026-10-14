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

// Colored frame around the screen. over_hud = true: the frame must be drawn ABOVE the hotbar and hearts.
void main() {
    vec3 src = texture(InSampler, texCoord).rgb;
    float d = min(min(texCoord.x, 1.0 - texCoord.x), min(texCoord.y, 1.0 - texCoord.y));
    float frame = 1.0 - smoothstep(Params.x, Params.x + 0.02, d);
    fragColor = vec4(mix(src, Color.rgb, frame * Control.x), 1.0);
}
