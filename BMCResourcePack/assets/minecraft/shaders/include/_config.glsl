// 1. Лёгкая дрожь (#FFB400)
TEXT_EFFECT(255, 180, 0) {
    apply_shaking_movement();
}

// 2. Сильная дрожь (#FFB409)
TEXT_EFFECT(255, 180, 9) {
    apply_shaking_movement();
    apply_shaking_movement();  // двойной вызов = сильнее
}

// 3. Плавное покачивание (волна 1) (#FFB40A)
TEXT_EFFECT(255, 180, 10) {
    apply_waving_movement(1.0, 1.5);
}

// 4. Сильная волна (#FFB40E)
TEXT_EFFECT(255, 180, 14) {
    apply_waving_movement(2.0, 2.0);
}

// 5. Редкие глитч-сдвиги (#FFB40F)
TEXT_EFFECT(255, 180, 15) {
    float n = noise(textData.characterPosition.x + textData.characterPosition.y + GameTime * 8000.0);
    if (n > 0.9) {
        textData.uv.x += 5.0 / 256.0;
        textData.shouldScale = true;
    }
}

// 6. Частые пропадания (глитч 5) (#FFB413)
TEXT_EFFECT(255, 180, 19) {
    float n = noise(textData.characterPosition + vec2(GameTime * 12000.0));
    if (n > 0.8) textData.color.a = 0.0;
}

// 7. Микро-движения + лёгкая статика (#FFB41F)
TEXT_EFFECT(255, 180, 31) {
    apply_shaking_movement();
    // добавляем шум на прозрачность
    textData.color.a *= 0.7 + 0.3 * noise(textData.localPosition * 32.0 + vec2(GameTime * 6400.0));
}

// 8. Bold-пульс редкий (#FFB419)
TEXT_EFFECT(255, 180, 25) {
    float pulse = sin(GameTime * 12800.0 * 0.7) * 0.5 + 0.5;
    if (pulse > 0.3) {
        textData.shouldScale = true;
        apply_outline(vec3(1.0, 0.2, 0.2));
    }
}

// 9. Bold-пульс частый (сирена) (#FFB431)
TEXT_EFFECT(255, 180, 49) {
    float pulse = sin(GameTime * 12800.0 * 3.0) * 0.5 + 0.5;
    if (pulse > 0.2) {
        textData.shouldScale = true;
        apply_outline(vec3(1.0, 0.8, 0.0));  // жёлтая обводка
    }
}

// 10. Хроматическая аберрация лёгкая (#FFB426)
TEXT_EFFECT(255, 180, 38) {
    apply_chromatic_abberation();
}

// 11. Сильная хроматическая аберрация (#FFB43B)
TEXT_EFFECT(255, 180, 59) {
    apply_chromatic_abberation();
    apply_chromatic_abberation();
}

// 12. Старая плёнка (#FFB44B)
TEXT_EFFECT(255, 180, 75) {
    apply_shimmer(2.0, 0.6);
    textData.color.a *= 0.7 + 0.3 * noise(textData.localPosition * 32.0 + vec2(GameTime * 6400.0));
}

// 13. Заикание (#FFB455)
TEXT_EFFECT(255, 180, 85) {
    float n = noise(textData.characterPosition + vec2(GameTime * 12000.0));
    if (n > 0.8) textData.color.a = 0.0;
    n = noise(textData.characterPosition + vec2(GameTime * 18000.0 + 1000.0));
    if (n > 0.85) textData.color.a = 0.0;
}

// 14. Мигание ярко-белым (#FFB45A)
TEXT_EFFECT(255, 180, 90) {
    apply_blinking(2.0);
}

// 15. Радужный перелив (#FFB45F)
TEXT_EFFECT(255, 180, 95) {
    apply_rainbow();
}

// 16. Кровавый отлив (#FFB464)
TEXT_EFFECT(255, 180, 100) {
    override_text_color(vec3(0.9, 0.1, 0.1));
    apply_fade(1.0);
}

// 17. Холодный синий + тусклость (#FFB469)
TEXT_EFFECT(255, 180, 105) {
    override_text_color(vec3(0.6, 0.7, 1.0));
    apply_fade(0.8);
}

// 18. Выцветание (пульсация прозрачности) (#FFB46E)
TEXT_EFFECT(255, 180, 110) {
    apply_fade(1.5);
}

// 19. Скачки яркости (#FFB473)
TEXT_EFFECT(255, 180, 115) {
    float jump = step(0.7, fract(GameTime * 800.0));
    textData.color.rgb *= 1.0 + jump * 0.5;
}

// 20. ЭЛТ-строки (#FFB47D)
TEXT_EFFECT(255, 180, 125) {
    textData.color.rgb *= sin(textData.uv.y * 300.0 + GameTime * 20.0) * 0.2 + 0.8;
}

// 21. Шум с пропаданием (#FFB482)
TEXT_EFFECT(255, 180, 130) {
    textData.color.a *= noise(textData.localPosition * 32.0 + vec2(GameTime * 6400.0));
    if (noise(textData.characterPosition + vec2(GameTime * 12000.0)) > 0.8) textData.color.a = 0.0;
}

// 22. Зеркальное отражение (#FFB48C)
TEXT_EFFECT(255, 180, 140) {
    textData.uv.x = textData.uvMax.x + textData.uvMin.x - textData.uv.x;
}

// 23. Виньетка (#FFB496)
TEXT_EFFECT(255, 180, 150) {
    textData.color.a *= 1.0 - length(textData.localPosition - 0.5) * 0.7;
}

// 24. Кровавое окрашивание (#FFB49B)
TEXT_EFFECT(255, 180, 155) {
    override_text_color(vec3(0.85, 0.05, 0.1));
    apply_fire();
}

// 25. Полный хаос (#FFB4FF)
TEXT_EFFECT(255, 180, 255) {
    apply_shaking_movement();
    apply_chromatic_abberation();
    float n = noise(textData.characterPosition + vec2(GameTime * 12000.0));
    if (n > 0.8) textData.color.a = 0.0;
    apply_rainbow();
    textData.shouldScale = true;
    apply_outline(vec3(1.0, 0.0, 0.0));
    textData.color.a *= 1.0 - length(textData.localPosition - 0.5) * 0.5;
}