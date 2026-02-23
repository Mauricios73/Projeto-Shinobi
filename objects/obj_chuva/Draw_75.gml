/// obj_chuva - Draw End
gpu_set_blendmode(bm_normal);
draw_set_color(make_color_rgb(210, 225, 255));

for (var i = 0; i < rain_active; i++)
{
    draw_set_alpha(ra[i]);
    draw_line(rx[i], ry[i], rx[i] + 0.45, ry[i] + rl[i] + 10);
}

draw_set_alpha(1);
draw_set_color(c_white);

