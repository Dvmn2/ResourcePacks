#moj_import <common.glsl>
#moj_import <offset.glsl>
#moj_import <defaults.glsl>
#moj_import <wavy.glsl>
#moj_import <shake.glsl>
#moj_import <text_effects_api.glsl>
#moj_import <apply_effect.glsl>

bool checkAndSetShadow(ivec3 c, int R, int G, int B) {
    if (c.r == R && c.g == G && c.b == B) {
        return true;
    }
    if (c.r == int(R/4) && c.g == int(G/4) && c.b == int(B/4)) {
        currentIsShadow = true;
        return currentIsShadow;
    }
    return false;
}

#define TEXT_EFFECT(R, G, B) \
    if (c.r == R && c.g == G && c.b == B)

#define TEXT_EFFECT_WITH_SHADOW(R, G, B) \
    if (checkAndSetShadow(c, R, G, B))

void applyTextEffects() {
    vec4 vertex = vec4(Position, 1.0);
    ivec3 c = ivec3(Color.rgb * 255.0 + 0.5);

    currentVertex = vertex;
    currentBaseColor = Color;
    currentIsShadow = false;
    currentApplyToShadow = false;

    #moj_import <_config.glsl>

    if (hasAnyEffect()) {
        applyEffect(currentVertex, currentBaseColor, currentIsShadow);
        return;
    }

    applyProjection(vertex);
    applyColorTexture();
    finalize();
}
