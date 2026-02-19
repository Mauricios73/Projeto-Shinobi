var w = display_get_gui_width();
var h = display_get_gui_height();
if (w <= 1) w = camera_get_view_width(view_camera[0]);
if (h <= 1) h = camera_get_view_height(view_camera[0]);

if (!init || w != gw || h != gh)
{
    init = true;
    gw = w; gh = h;

    sx = array_create(snow_n);
    sy = array_create(snow_n);
    sp = array_create(snow_n);
    ss = array_create(snow_n);
    sa = array_create(snow_n);
    ph = array_create(snow_n);
    lay = array_create(snow_n); // 0 longe, 1 perto
	

    for (var i = 0; i < snow_n; i++)
    {
        sx[i] = random(gw);
        sy[i] = random(gh);
        ph[i] = irandom(999999);

        if (i < snow_n * 0.55) lay[i] = 0; else lay[i] = 1;

        if (lay[i] == 0) {
            sp[i] = random_range(0.25, 0.65);
            ss[i] = choose(1,1,1,2);
            sa[i] = random_range(0.15, 0.35);
        } else {
            sp[i] = random_range(0.70, 1.55);
            ss[i] = choose(1,2,2,3);
            sa[i] = random_range(0.35, 0.70);
        }
    }
}

var wind = wind_base + sin(current_time * wind_speed) * wind_amp;

// move
for (var i = 0; i < snow_n; i++)
{
    var drift_strength;
    if (lay[i] == 1) drift_strength = 0.35; else drift_strength = 0.18;

    var drift = sin((current_time + ph[i]) * 0.002 + sy[i] * 0.03) * drift_strength;

    sx[i] += wind + drift;
    sy[i] += sp[i];

    if (sy[i] > gh + 8) { sy[i] = -8; sx[i] = random(gw); }
	if (sy[i] > gh + 8) { sy[i] = safe_top - 8; sx[i] = random(gw); }
    if (sx[i] > gw + 8) sx[i] = -8;
    if (sx[i] < -8)     sx[i] = gw + 8;
}
