/// obj_menu_atmosphere - Step

var cam = view_camera[0];

var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);
var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);

var dt = 1 / room_speed;

// ------------------------------------------------------------
// VENTO
// ------------------------------------------------------------
wind_timer -= dt;

if (wind_timer <= 0)
{
    wind_timer = random_range(4, 9);
    wind_gust_target = random_range(0.15, 0.55);
}

wind_gust = lerp(wind_gust, wind_gust_target, 0.035);
wind_gust_target = lerp(wind_gust_target, 0, 0.01);

wind_target =
    0.30
    + sin(current_time * 0.00055) * 0.16
    + wind_gust;

wind = lerp(wind, wind_target, 0.04);

global.menu_wind = wind;

// ------------------------------------------------------------
// FOLHAS
// ------------------------------------------------------------
for (var i = 0; i < leaf_count; i++)
{
    var sway =
        sin((current_time + leaf_phase[i]) * 0.0022)
        * (0.20 + wind * 0.22);

    leaf_x[i] += leaf_vx[i] + wind * 0.55 + sway;
    leaf_y[i] += leaf_vy[i] + sin((current_time + leaf_phase[i]) * 0.0014) * 0.12;

    leaf_rot[i] += leaf_rot_speed[i] + wind * 0.15;

    // reaparece pela esquerda
    if (leaf_x[i] > vx + vw + 24)
    {
        leaf_x[i] = vx - 24;
        leaf_y[i] = vy + random(vh);
        leaf_scale[i] = random_range(2.65, 3.15);
        leaf_alpha[i] = random_range(0.28, 0.65);
    }

    if (leaf_y[i] > vy + vh + 24)
    {
        leaf_y[i] = vy - 12;
        leaf_x[i] = vx + random(vw);
    }
}
