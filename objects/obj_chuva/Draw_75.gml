gpu_set_blendmode(bm_normal);
draw_set_color(make_color_rgb(210, 225, 255));

var wind = wind_base + sin(current_time * wind_speed) * wind_amp;

for (var i = 0; i < rain_n; i++)
{
    draw_set_alpha(ra[i]);

    var x1 = rx[i];
    var y1 = ry[i];

    draw_line(x1, y1, x1 + wind * 0.45, y1 + rl[i] + 10); // mais longa
}

draw_set_alpha(1);
draw_set_color(c_white);
	