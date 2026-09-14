/// obj_menu_atmosphere - Draw

gpu_set_blendmode(bm_normal);

for (var i = 0; i < leaf_count; i++)
{
    var _x = leaf_x[i];
    var _y = leaf_y[i];
    var _s = leaf_scale[i];

    var _leaf_color = make_color_rgb(116, 91, 50);

    draw_set_color(_leaf_color);
    draw_set_alpha(leaf_alpha[i]);

    // Rotacao da folha
    var _angle = leaf_rot[i];

    // Comprimento e largura
    var _dx = lengthdir_x(5 * _s, _angle);
    var _dy = lengthdir_y(5 * _s, _angle);

    var _px = lengthdir_x(2.2 * _s, _angle + 90);
    var _py = lengthdir_y(2.2 * _s, _angle + 90);

    // Corpo da folha
    draw_primitive_begin(pr_trianglefan);

    draw_vertex(_x, _y);

    draw_vertex(
        _x + _dx + _px,
        _y + _dy + _py
    );

    draw_vertex(
        _x + _dx,
        _y + _dy
    );

    draw_vertex(
        _x + _dx - _px,
        _y + _dy - _py
    );

    draw_primitive_end();

    // Nervura da folha
    draw_set_alpha(leaf_alpha[i] * 0.65);
    draw_set_color(make_color_rgb(55, 48, 34));

    draw_line(
        _x,
        _y,
        _x + _dx,
        _y + _dy
    );
}

// Restaurar estado do Draw
draw_set_alpha(1);
draw_set_color(c_white);
gpu_set_blendmode(bm_normal);