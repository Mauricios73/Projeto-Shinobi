gpu_set_blendmode(bm_normal);
draw_set_color(make_color_rgb(210, 225, 255));

var cam = view_camera[0];
var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);

var wind = wind_base + sin(current_time * wind_speed) * wind_amp;

for (var i = 0; i < rain_active; i++)
{
    draw_set_alpha(ra[i]);

    var x1 = vx + rx[i];
    var y1 = vy + ry[i];

    draw_line(x1, y1, x1 + wind * 0.45, y1 + rl[i] + 10);
}

draw_set_alpha(1);
draw_set_color(c_white);