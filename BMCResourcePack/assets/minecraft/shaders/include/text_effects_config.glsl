// ========== ХОРРОР-ЭФФЕКТЫ (G=180) ==========

// 1. Лёгкая дрожь – белая (#FFB400)
TEXT_EFFECT(255, 180, 0) {
    override_text_color(rgb(255,255,255));
    apply_shaking_movement();
}
// 1а. Лёгкая дрожь – бордовая (#FFB404)
TEXT_EFFECT(255, 180, 4) {
    override_text_color(rgb(128,0,0));
    apply_shaking_movement();
}
// 1б. Лёгкая дрожь – тёмная (#FFB408)
TEXT_EFFECT(255, 180, 8) {
    override_text_color(rgb(30,30,30));
    apply_shaking_movement();
}

// 2. Сильная дрожь – белая (#FFB40C)
TEXT_EFFECT(255, 180, 12) {
    override_text_color(rgb(255,255,255));
    apply_shaking_movement();
    apply_shaking_movement();
}
// 2а. Сильная дрожь – бордовая (#FFB410)
TEXT_EFFECT(255, 180, 16) {
    override_text_color(rgb(128,0,0));
    apply_shaking_movement();
    apply_shaking_movement();
}

// 3. Плавное покачивание – белое (#FFB414)
TEXT_EFFECT(255, 180, 20) {
    override_text_color(rgb(255,255,255));
    apply_waving_movement();
}
// 3а. Плавное покачивание – тёмное (#FFB418)
TEXT_EFFECT(255, 180, 24) {
    override_text_color(rgb(40,40,40));
    apply_waving_movement();
}

// 4. Сильная волна – белая (#FFB41C)
TEXT_EFFECT(255, 180, 28) {
    override_text_color(rgb(255,255,255));
    apply_waving_movement();
    apply_waving_movement();
}

// 5. Редкие глитч-сдвиги – белые (#FFB420)
TEXT_EFFECT(255, 180, 32) {
    override_text_color(rgb(255,255,255));
    float n = noise(textData.characterPosition.x + textData.characterPosition.y + GameTime * 8000.0);
    if (n > 0.9) {
        textData.uv.x += 5.0 / 256.0;
        textData.shouldScale = true;
    }
}
// 5а. Глитч-сдвиги – кровавые (#FFB424)
TEXT_EFFECT(255, 180, 36) {
    override_text_color(rgb(200,0,0));
    float n = noise(textData.characterPosition.x + textData.characterPosition.y + GameTime * 8000.0);
    if (n > 0.9) {
        textData.uv.x += 5.0 / 256.0;
        textData.shouldScale = true;
    }
}

// 6. Частые пропадания – белые (#FFB428)
TEXT_EFFECT(255, 180, 40) {
    override_text_color(rgb(255,255,255));
    float n = noise(textData.characterPosition.x * 10.0 + textData.characterPosition.y * 7.0 + GameTime * 12000.0);
    if (n > 0.8) textData.color.a = 0.0;
}
// 6а. Частые пропадания – тёмные (#FFB42C)
TEXT_EFFECT(255, 180, 44) {
    override_text_color(rgb(20,20,20));
    float n = noise(textData.characterPosition.x * 10.0 + textData.characterPosition.y * 7.0 + GameTime * 12000.0);
    if (n > 0.8) textData.color.a = 0.0;
}

// 7. Микро-движения + статика – белые (#FFB430)
TEXT_EFFECT(255, 180, 48) {
    override_text_color(rgb(255,255,255));
    apply_shaking_movement();
    float n = noise(textData.localPosition.x * 32.0 + textData.localPosition.y * 32.0 + GameTime * 6400.0);
    textData.color.a *= 0.7 + 0.3 * n;
}

// 8. Bold-пульс редкий – белый (#FFB434)
TEXT_EFFECT(255, 180, 52) {
    override_text_color(rgb(255,255,255));
    float pulse = sin(GameTime * 12800.0 * 0.7) * 0.5 + 0.5;
    if (pulse > 0.3) {
        textData.shouldScale = true;
    }
}
// 8а. Bold-пульс редкий – бордовый (#FFB438)
TEXT_EFFECT(255, 180, 56) {
    override_text_color(rgb(100,0,0));
    float pulse = sin(GameTime * 12800.0 * 0.7) * 0.5 + 0.5;
    if (pulse > 0.3) {
        textData.shouldScale = true;
    }
}

// 9. Сирена (исправлена) – белая (#FFB43C)
TEXT_EFFECT(255, 180, 60) {
    override_text_color(rgb(255,255,255));
    if (sin(GameTime * 12800.0 * 3.0) > 0.0) {
        apply_shaking_movement();
        textData.shouldScale = true;
    }
}
// 9а. Сирена – красная (#FFB440)
TEXT_EFFECT(255, 180, 64) {
    override_text_color(rgb(255,0,0));
    if (sin(GameTime * 12800.0 * 3.0) > 0.0) {
        apply_shaking_movement();
        textData.shouldScale = true;
    }
}

// 10. Хром.аберрация лёгкая – белая (#FFB444)
TEXT_EFFECT(255, 180, 68) {
    override_text_color(rgb(255,255,255));
    apply_chromatic_abberation();
}

// 11. Сильная хром.аберрация – белая (#FFB448)
TEXT_EFFECT(255, 180, 72) {
    override_text_color(rgb(255,255,255));
    apply_chromatic_abberation();
    apply_chromatic_abberation();
}

// 12. Старая плёнка (#FFB44C)
TEXT_EFFECT(255, 180, 76) {
    override_text_color(rgb(220,210,180));
    apply_shimmer(2.0, 0.6);
    float n = noise(textData.localPosition.x * 32.0 + textData.localPosition.y * 32.0 + GameTime * 6400.0);
    textData.color.a *= 0.7 + 0.3 * n;
}

// 13. Заикание – белое (#FFB450)
TEXT_EFFECT(255, 180, 80) {
    override_text_color(rgb(255,255,255));
    float n1 = noise(textData.characterPosition.x * 10.0 + textData.characterPosition.y * 7.0 + GameTime * 12000.0);
    if (n1 > 0.8) textData.color.a = 0.0;
    float n2 = noise(textData.characterPosition.x * 13.0 + textData.characterPosition.y * 11.0 + GameTime * 18000.0 + 1000.0);
    if (n2 > 0.85) textData.color.a = 0.0;
}

// 14. Мигание ярко-белым (#FFB454)
TEXT_EFFECT(255, 180, 84) {
    override_text_color(rgb(255,255,255));
    apply_blinking(2.0);
}
// 14а. Мигание – красное (#FFB458)
TEXT_EFFECT(255, 180, 88) {
    override_text_color(rgb(255,0,0));
    apply_blinking(2.0);
}

// 15. Радужный перелив (#FFB45C)
TEXT_EFFECT(255, 180, 92) {
    apply_rainbow();
}

// 16. Кровавый отлив (#FFB460)
TEXT_EFFECT(255, 180, 96) {
    override_text_color(rgb(230,20,20));
    apply_fade(1.0);
}

// 17. Холодный синий (#FFB464)
TEXT_EFFECT(255, 180, 100) {
    override_text_color(rgb(150,180,255));
    apply_fade(0.8);
}
// 17а. Холодный тёмно-синий (#FFB468)
TEXT_EFFECT(255, 180, 104) {
    override_text_color(rgb(30,40,80));
    apply_fade(0.8);
}

// 18. Выцветание – белое (#FFB46C)
TEXT_EFFECT(255, 180, 108) {
    override_text_color(rgb(255,255,255));
    apply_fade(1.5);
}

// 19. Скачки яркости – белые (#FFB470)
TEXT_EFFECT(255, 180, 112) {
    override_text_color(rgb(255,255,255));
    float jump = step(0.7, fract(GameTime * 800.0));
    textData.color.rgb *= 1.0 + jump * 0.5;
}

// 20. ЭЛТ-строки – белые (#FFB474)
TEXT_EFFECT(255, 180, 116) {
    override_text_color(rgb(255,255,255));
    textData.color.rgb *= sin(textData.uv.y * 300.0 + GameTime * 20.0) * 0.2 + 0.8;
}

// 21. Шум с пропаданием – белый (#FFB478)
TEXT_EFFECT(255, 180, 120) {
    override_text_color(rgb(255,255,255));
    float n = noise(textData.localPosition.x * 32.0 + textData.localPosition.y * 32.0 + GameTime * 6400.0);
    textData.color.a *= n;
    float n2 = noise(textData.characterPosition.x * 10.0 + textData.characterPosition.y * 7.0 + GameTime * 12000.0);
    if (n2 > 0.8) textData.color.a = 0.0;
}

// 22. Зеркальное отражение – белое (#FFB47C)
TEXT_EFFECT(255, 180, 124) {
    override_text_color(rgb(255,255,255));
    textData.uv.x = textData.uvMax.x + textData.uvMin.x - textData.uv.x;
}

// 23. Виньетка – белая (#FFB480)
TEXT_EFFECT(255, 180, 128) {
    override_text_color(rgb(255,255,255));
    float vignette = 1.0 - length(textData.localPosition - 0.5) * 0.7;
    textData.color.a *= vignette;
}

// 24. Кровавое окрашивание (#FFB484)
TEXT_EFFECT(255, 180, 132) {
    override_text_color(rgb(180,10,10));
    apply_fire();
}

// 25. Полный хаос (#FFB488)
TEXT_EFFECT(255, 180, 136) {
    override_text_color(rgb(255,255,255));
    apply_shaking_movement();
    apply_chromatic_abberation();
    float n = noise(textData.characterPosition.x * 10.0 + textData.characterPosition.y * 7.0 + GameTime * 12000.0);
    if (n > 0.8) textData.color.a = 0.0;
    apply_rainbow();
    textData.shouldScale = true;
    float vignette = 1.0 - length(textData.localPosition - 0.5) * 0.5;
    textData.color.a *= vignette;
}

// 26. Дрожащий курсив (старая бумага) (#FFB48C)
TEXT_EFFECT(255, 180, 140) {
    override_text_color(rgb(240,230,210));
    apply_shaking_movement();
    apply_skewing_movement(1.2);
}

// 27. Размытые чернила (#FFB490)
TEXT_EFFECT(255, 180, 144) {
    override_text_color(rgba(180,170,150,220));
    apply_fade(0.4);
    apply_waving_movement(0.3, 0.8);
}

// 28. Капли крови (#FFB494)
TEXT_EFFECT(255, 180, 148) {
    override_text_color(rgb(190,0,0));
    apply_fire();
    apply_shaking_movement();
}

// 29. Печатная машинка (#FFB498)
TEXT_EFFECT(255, 180, 152) {
    override_text_color(rgb(60,60,60));
    apply_shaking_movement();
    float n = noise(textData.characterPosition.x * 5.0 + GameTime * 500.0);
    textData.color.rgb *= 0.7 + 0.6 * n;
}

// 30. Теневой шёпот (#FFB49C)
TEXT_EFFECT(255, 180, 156) {
    override_text_color(rgb(220,220,240));
    apply_waving_movement(0.7, 1.2);
    apply_vertical_shadow();
}

// 31. Мерцающая аура (#FFB4A0)
TEXT_EFFECT(255, 180, 160) {
    override_text_color(rgb(200,230,255));
    apply_glowing();
}

// 32. Выцветший дневник (без волны) (#FFB4A4)
TEXT_EFFECT(255, 180, 164) {
    override_text_color(rgba(160,140,110,180));
    apply_fade(0.6);
}

// 33. Затухающий крик (#FFB4A8)
TEXT_EFFECT(255, 180, 168) {
    override_text_color(rgb(255,255,255));
    apply_blinking(3.0);
    apply_shaking_movement();
}

// 34. Мимикрирующий текст (#FFB4AC)
TEXT_EFFECT(255, 180, 172) {
    override_text_color(rgba(255,255,255,60));
    apply_waving_movement(0.2, 0.5);
    apply_fade(0.3);
}

// 35. Silent Hill (#FFB4B0)
TEXT_EFFECT(255, 180, 176) {
    override_text_color(rgb(160,140,110));
    apply_shaking_movement();
    apply_shimmer(2.0, 0.8);
    apply_chromatic_abberation();
    float n = noise(textData.localPosition.x * 32.0 + textData.localPosition.y * 32.0 + GameTime * 6400.0);
    textData.color.a *= 0.6 + 0.4 * n;
}

// 36. Туман (без волны) (#FFB4B4)
TEXT_EFFECT(255, 180, 180) {
    apply_gradient(rgb(230,230,240), rgb(180,180,200));
    apply_fade(0.7);
    textData.shouldScale = true;
}

// 37. Кровавый след (#FFB4B8)
TEXT_EFFECT(255, 180, 184) {
    override_text_color(rgb(150,0,0));
    apply_fire();
    apply_waving_movement(0.4, 0.8);
}

// 38. Заражение (#FFB4BC)
TEXT_EFFECT(255, 180, 188) {
    override_text_color(rgb(80,200,80));
    apply_blinking(3.0);
    apply_shaking_movement();
}

// 39. Эхо (#FFB4C0)
TEXT_EFFECT(255, 180, 192) {
    override_text_color(rgb(200,200,200));
    apply_chromatic_abberation();
    apply_waving_movement(1.5, 0.5);
}

// 40. Ледяной ужас (#FFB4C4)
TEXT_EFFECT(255, 180, 196) {
    override_text_color(rgb(150,200,255));
    apply_shaking_movement();
    apply_fade(0.6);
}

// 41. Теневой ползучий (#FFB4C8)
TEXT_EFFECT(255, 180, 200) {
    override_text_color(rgb(20,20,20));
    apply_waving_movement(0.8, 1.0);
    apply_glowing();
}

// 42. Мерцание неона (#FFB4CC)
TEXT_EFFECT(255, 180, 204) {
    override_text_color(rgb(255,0,200));
    apply_blinking(5.0);
}

// 43. Гнилая бумага (#FFB4D0)
TEXT_EFFECT(255, 180, 208) {
    override_text_color(rgb(100,80,50));
    float n = noise(textData.localPosition.x * 32.0 + textData.localPosition.y * 32.0 + GameTime * 6400.0);
    textData.color.a *= 0.5 + 0.5 * n;
}

// 44. Призрачный шёпот (#FFB4D4)
TEXT_EFFECT(255, 180, 212) {
    override_text_color(rgba(255,255,255,120));
    apply_waving_movement(0.3, 0.6);
    apply_fade(0.5);
}

// 45. Кошмар (#FFB4D8)
TEXT_EFFECT(255, 180, 216) {
    override_text_color(rgb(255,255,255));
    apply_rainbow();
    apply_shaking_movement();
    apply_chromatic_abberation();
}

// 46. Дыхание тьмы (#FFB4DC)
TEXT_EFFECT(255, 180, 220) {
    override_text_color(rgb(0,0,0));
    apply_glowing();
    apply_shaking_movement();
}

// 47. Искажение (#FFB4E0)
TEXT_EFFECT(255, 180, 224) {
    override_text_color(rgb(255,255,255));
    apply_skewing_movement(2.0);
    apply_chromatic_abberation();
}

// 48. Разрыв реальности (#FFB4E4)
TEXT_EFFECT(255, 180, 228) {
    override_text_color(rgb(255,255,255));
    float n = noise(textData.characterPosition.x * 10.0 + GameTime * 8000.0);
    if (n > 0.7) textData.color.a = 0.0;
    apply_shaking_movement();
    apply_waving_movement(2.0, 0.3);
}

// 49. Кровавый дождь (#FFB4E8)
TEXT_EFFECT(255, 180, 232) {
    override_text_color(rgb(180,0,0));
    apply_fire();
    float n = noise(textData.localPosition.y * 50.0 + GameTime * 2000.0);
    textData.uv.y += n / 256.0;
    textData.shouldScale = true;
}

// 50. Стон (#FFB4EC)
TEXT_EFFECT(255, 180, 236) {
    override_text_color(rgb(180,180,180));
    apply_fade(0.9);
    apply_shaking_movement();
}

// 51. Вспышка (#FFB4F0)
TEXT_EFFECT(255, 180, 240) {
    override_text_color(rgb(255,255,255));
    float flash = step(0.95, fract(GameTime * 5000.0));
    textData.color.rgb *= 1.0 + flash * 2.0;
}

// 52. Слепота (#FFB4F4)
TEXT_EFFECT(255, 180, 244) {
    override_text_color(rgb(255,255,255));
    apply_blinking(10.0);
    textData.shouldScale = true;
}

// 53. Кошмарная трясина (#FFB4F8)
TEXT_EFFECT(255, 180, 248) {
    override_text_color(rgb(50,50,50));
    apply_waving_movement(0.5, 0.5);
    apply_shaking_movement();
    apply_fade(0.8);
}

// 54. Красный ужас (#FFB4FC)
TEXT_EFFECT(255, 180, 252) {
    override_text_color(rgb(255,0,0));
    apply_shaking_movement();
    apply_shaking_movement();
    apply_blinking(4.0);
}

// ========== ТЕМАТИЧЕСКИЕ ЭФФЕКТЫ (G=176) ==========

// --- ГОТОВКА ---
TEXT_EFFECT(255, 176, 0) { // #FFB000
    override_text_color(rgb(255,200,50));
    apply_fire();
    apply_shaking_movement();
}
TEXT_EFFECT(255, 176, 4) { // #FFB004
    override_text_color(rgb(255,255,255));
    apply_waving_movement(0.8, 0.3);
    apply_fade(0.6);
}
TEXT_EFFECT(255, 176, 8) { // #FFB008
    override_text_color(rgb(255,180,30));
    apply_shimmer(3.0, 0.7);
}
TEXT_EFFECT(255, 176, 12) { // #FFB00C
    override_text_color(rgb(230,70,30));
    float pulse = sin(GameTime * 12800.0 * 4.0) * 0.5 + 0.5;
    textData.shouldScale = true;
    textData.color.rgb *= 1.0 + pulse * 0.3;
}

// --- НАПИТКИ ---
TEXT_EFFECT(255, 176, 16) { // #FFB010
    override_text_color(rgb(255,255,100));
    apply_waving_movement(0.6, 0.8);
    float bubble = step(0.7, noise(textData.characterPosition.y * 30.0 + GameTime * 5000.0));
    textData.uv.y += bubble * 2.0 / 256.0;
    textData.shouldScale = true;
}
TEXT_EFFECT(255, 176, 20) { // #FFB014
    override_text_color(rgb(60,40,20));
    apply_waving_movement(0.3, 0.5);
    apply_fade(0.7);
}
TEXT_EFFECT(255, 176, 24) { // #FFB018
    apply_gradient(rgb(255,100,100), rgb(100,255,100));
    apply_waving_movement(0.4, 1.0);
}
TEXT_EFFECT(255, 176, 28) { // #FFB01C
    override_text_color(rgb(250,245,235));
    apply_waving_movement(0.2, 0.3);
}

// --- ТЕЛЕФОН / ГАДЖЕТЫ ---
TEXT_EFFECT(255, 176, 32) { // #FFB020
    override_text_color(rgb(0,150,255));
    apply_blinking(3.0);
}
TEXT_EFFECT(255, 176, 36) { // #FFB024
    override_text_color(rgb(0,255,100));
    float pulse = sin(GameTime * 12800.0 * 2.0) * 0.5 + 0.5;
    textData.color.a *= 0.6 + 0.4 * pulse;
}
TEXT_EFFECT(255, 176, 40) { // #FFB028
    override_text_color(rgb(255,255,255));
    apply_shaking_movement();
    apply_shaking_movement();
}
TEXT_EFFECT(255, 176, 44) { // #FFB02C
    override_text_color(rgb(200,0,255));
    apply_glowing();
    apply_blinking(5.0);
}

// --- УКРАШЕНИЯ ---
TEXT_EFFECT(255, 176, 48) { // #FFB030
    apply_metalic(rgb(200,200,200));
}
TEXT_EFFECT(255, 176, 52) { // #FFB034
    apply_metalic(rgb(255,215,0));
    apply_shimmer(2.0, 0.5);
}
TEXT_EFFECT(255, 176, 56) { // #FFB038
    override_text_color(rgba(220,240,255,200));
    apply_glowing();
    apply_waving_movement(0.3, 0.4);
}
TEXT_EFFECT(255, 176, 60) { // #FFB03C
    apply_rainbow();
    apply_shimmer(4.0, 0.9);
}

// ========== ТЕМАТИЧЕСКИЕ ЭФФЕКТЫ (G=184) ==========

// --- ЭМОЦИИ / СИТУАЦИИ ---
TEXT_EFFECT(255, 184, 0) { // #FFB800
    override_text_color(rgb(255,255,0));
    apply_waving_movement(1.0, 2.0);
}
TEXT_EFFECT(255, 184, 4) { // #FFB804
    override_text_color(rgb(100,150,255));
    apply_waving_movement(0.2, 0.5);
    apply_fade(0.5);
}
TEXT_EFFECT(255, 184, 8) { // #FFB808
    override_text_color(rgb(255,0,0));
    apply_shaking_movement();
    apply_shaking_movement();
}
TEXT_EFFECT(255, 184, 12) { // #FFB80C
    override_text_color(rgb(255,255,0));
    float jump = step(0.8, fract(GameTime * 500.0));
    textData.uv.y += jump * 3.0 / 256.0;
    textData.shouldScale = true;
}
TEXT_EFFECT(255, 184, 16) { // #FFB810
    override_text_color(rgb(200,200,255));
    apply_fade(0.4);
    apply_waving_movement(0.1, 0.3);
}
TEXT_EFFECT(255, 184, 20) { // #FFB814
    override_text_color(rgb(120,100,180));
    apply_shimmer(1.5, 0.4);
}
TEXT_EFFECT(255, 184, 24) { // #FFB818
    apply_rainbow();
    apply_blinking(1.5);
}
TEXT_EFFECT(255, 184, 28) { // #FFB81C
    override_text_color(rgb(255,255,255));
    apply_rainbow();
    apply_glowing();
}
TEXT_EFFECT(255, 184, 32) { // #FFB820
    override_text_color(rgb(255,150,200));
    float pulse = sin(GameTime * 12800.0 * 1.2) * 0.5 + 0.5;
    textData.shouldScale = true;
    textData.color.rgb *= 1.0 + pulse * 0.2;
}
TEXT_EFFECT(255, 184, 36) { // #FFB824
    override_text_color(rgb(200,220,240));
    apply_waving_movement(1.5, 0.2);
    textData.uv.x += 1.0 / 256.0;
    textData.shouldScale = true;
}
TEXT_EFFECT(255, 184, 40) { // #FFB828
    override_text_color(rgb(100,180,255));
    apply_waving_movement(1.0, 0.6);
    apply_fade(0.8);
}
TEXT_EFFECT(255, 184, 44) { // #FFB82C
    override_text_color(rgb(255,100,0));
    apply_fire();
}