/// obj_menu_atmosphere - Create
/// Folhas ambientais exclusivas do menu.

depth = 35;

leaf_count = 28;

leaf_x = array_create(leaf_count);
leaf_y = array_create(leaf_count);
leaf_vx = array_create(leaf_count);
leaf_vy = array_create(leaf_count);
leaf_rot = array_create(leaf_count);
leaf_rot_speed = array_create(leaf_count);
leaf_phase = array_create(leaf_count);
leaf_scale = array_create(leaf_count);
leaf_alpha = array_create(leaf_count);

wind = 0.35;
wind_target = 0.35;
wind_gust = 0;
wind_gust_target = 0;
wind_timer = random_range(3, 8);

var cam = view_camera[0];
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);
var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);

for (var i = 0; i < leaf_count; i++)
{
    leaf_x[i] = vx + random(vw);
    leaf_y[i] = vy + random(vh);

    leaf_vx[i] = random_range(0.10, 0.40);
    leaf_vy[i] = random_range(0.10, 0.35);

    leaf_rot[i] = random(360);
    leaf_rot_speed[i] = random_range(-2.0, 2.0);

    leaf_phase[i] = random(10000);

    leaf_scale[i] = random_range(0.65, 1.15);
    leaf_alpha[i] = random_range(0.28, 0.65);
}
