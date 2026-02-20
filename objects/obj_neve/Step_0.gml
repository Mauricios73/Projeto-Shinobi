var cam = view_camera[0];

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

// ================= INIT =================
if (!init)
{
    init = true;

    sx = array_create(snow_n);
    sy = array_create(snow_n);
    sp = array_create(snow_n);
    ss = array_create(snow_n);
    sa = array_create(snow_n);
    ph = array_create(snow_n);
    lay = array_create(snow_n);

    for (var i = 0; i < snow_n; i++)
    {
        sx[i] = random(cam_w);
        sy[i] = random_range(-cam_h, 0);
        ph[i] = irandom(999999);

        lay[i] = (i < snow_n * 0.55) ? 0 : 1;

        if (lay[i] == 0)
        {
            sp[i] = random_range(0.25, 0.65);
            ss[i] = choose(1,1,1,2);
            sa[i] = random_range(0.15, 0.35);
        }
        else
        {
            sp[i] = random_range(0.7, 1.2);
            ss[i] = choose(1,2,2,3);
            sa[i] = random_range(0.35, 0.65);
        }
    }
}

// ================= WIND =================
var wind = wind_base + sin(current_time * wind_speed) * wind_amp;

// ================= MOVE =================
for (var i = 0; i < snow_n; i++)
{
    var drift_strength = (lay[i] == 1) ? 0.35 : 0.18;
    var drift = sin((current_time + ph[i]) * 0.002 + sy[i] * 0.03) * drift_strength;

    sx[i] += wind + drift;
    sy[i] += sp[i];

    // converter GUI → mundo
    var world_x = cam_x + sx[i];
    var world_y = cam_y + sy[i];



    // ================= SAIU DA TELA =================
    if (sy[i] > cam_h + 10)
    {
        sy[i] = random_range(-40, -10);
        sx[i] = random(cam_w);
    }

    if (sx[i] > cam_w + 8) sx[i] = -8;
    if (sx[i] < -8)        sx[i] = cam_w + 8;
}
