var w = display_get_gui_width();
var h = display_get_gui_height();

if (w <= 1) w = camera_get_view_width(view_camera[0]);
if (h <= 1) h = camera_get_view_height(view_camera[0]);

if (!init || w != gw || h != gh)
{
    init = true;
    gw = w;
    gh = h;

    rx = array_create(rain_n);
    ry = array_create(rain_n);
    rv = array_create(rain_n);
    rl = array_create(rain_n);
    ra = array_create(rain_n);
    ph = array_create(rain_n);

    for (var i = 0; i < rain_n; i++)
    {
        rx[i] = random(gw);
        ry[i] = random_range(safe_top, gh);
        rv[i] = random_range(10, 18);
        rl[i] = irandom_range(10, 22);
        ra[i] = random_range(0.10, 0.26);
        ph[i] = irandom(999999);
    }
}

// ✅ AQUI ESTAVA FALTANDO
var wind = wind_base + sin(current_time * wind_speed) * wind_amp;

// move
for (var i = 0; i < rain_n; i++)
{
    var wx = wind + sin((current_time + ph[i]) * 0.002) * 0.6;

    rx[i] += wx;
    ry[i] += rv[i];

    // Se atingiu a água
    if (variable_global_exists("lake_gui_top"))
    {
        if (ry[i] >= global.lake_gui_top)
        {
            if (instance_exists(obj_lake_v2))
            {
                with (obj_lake_v2)
                {
                    var id_ripple = irandom(ripple_max - 1);
                    ripple_x[id_ripple] = other.rx[i];
                    ripple_y[id_ripple] = 2;
                    ripple_r[id_ripple] = 1;
                    ripple_a[id_ripple] = 0.6;
                }
            }

            ry[i] = -20;
            rx[i] = random(gw);
            continue;
        }
    }

    if (ry[i] > gh + 20)
    {
        ry[i] = -20;
        rx[i] = random(gw);
    }

    if (rx[i] > gw + 20) rx[i] = -20;
    if (rx[i] < -20)     rx[i] = gw + 20;
}
