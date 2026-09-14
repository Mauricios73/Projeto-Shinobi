draw_self();

if(mostra_estado){
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_text(x, y - sprite_height * .5, estado)
	draw_set_valign(-1);
	draw_set_halign(-1);
}

/// ============================================================
/// DEBUG DA HITBOX DO PLAYER
/// ============================================================

draw_self();


// ============================================================
// HITBOX FÍSICA
// ============================================================

draw_set_alpha(0.45);
draw_set_color(c_red);

draw_rectangle(
    x + col_left,
    y + col_top,
    x + col_right,
    y + col_bottom,
    false
);


// ============================================================
// SENSOR DE CHÃO
// ============================================================

draw_set_alpha(0.8);
draw_set_color(c_lime);

draw_line(
    x + col_left + 1,
    y + col_bottom,
    x + col_right - 1,
    y + col_bottom + ground_probe
);


// ============================================================
// SENSOR PAREDE ESQUERDA
// ============================================================

draw_set_color(c_aqua);

draw_line(
    x + col_left,
    y + col_top + 3,
    x + col_left - wall_probe,
    y + col_bottom - 3
);


// ============================================================
// SENSOR PAREDE DIREITA
// ============================================================

draw_line(
    x + col_right,
    y + col_top + 3,
    x + col_right + wall_probe,
    y + col_bottom - 3
);


// ============================================================
// SENSOR DE TETO
// ============================================================

draw_set_color(c_yellow);

draw_line(
    x + col_left + 1,
    y + col_top,
    x + col_right - 1,
    y + col_top - ceiling_probe
);


// ============================================================
// RESTAURA DRAW
// ============================================================

draw_set_alpha(1);
draw_set_color(c_white);