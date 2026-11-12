void applyEffect(inout vec4 vertex, vec4 baseColor, bool isShadow) {
    vec4 displayColor = isShadow ? vec4(baseColor.rgb * 0.25, 1.0) : baseColor;

    if (flagShake) {
        float charId = floor(float(gl_VertexID) / 4.0);
        float shakeTime = GameTime * 32000.0 * paramShakeSpeed;
        float noiseX = noise(charId * 10.0 + shakeTime) - 0.5;
        float noiseY = noise(charId * 10.0 - shakeTime + 100.0) - 0.5;
        setOffset(noiseX * paramShakeIntensity, noiseY * paramShakeIntensity);
        applyOffset(vertex);
    }

    if (flagWavy) {
    	float charId = floor(float(gl_VertexID) / 4.0);
    	float wave = sin(GameTime * paramWaveSpeed + charId * paramWaveXFrequency) * paramWaveAmplitude;
    	setOffset(0.0, wave);
    	applyOffset(vertex);
    }

    applyProjection(vertex);
    vertexColor = displayColor;
    applyColorTexture();

    gl_Position.z -= 0.001;

    finalize();
}
