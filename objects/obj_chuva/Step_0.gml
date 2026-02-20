var cam = view_camera[0];
var w = camera_get_view_width(cam);
var h = camera_get_view_height(cam);
var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);


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

// Se atingiu a água (lake_gui_top está em coords da VIEW)
if (variable_global_exists("lake_gui_top"))
{
    if (ry[i] >= global.lake_gui_top)
    {
        // não é toda gota (Kingdom é sutil)
        if (irandom(99) < 28)
        {
            if (instance_exists(obj_lake_v3))
            {
                var drop_wx = vx + rx[i]; // X no mundo
                var strength = 1.0;

                with (obj_lake_v3)
                {
                    // 1) ripple na superfície (sempre quando passar no sorteio)
                    //add_ripple(drop_wx, strength, 2, true);

                    // 2) ripple no meio do lago (mais fraco e mais profundo)
                    if (irandom(99) < 55) // chance do “meio”
                    {
                        var mid = irandom_range(floor(lake_h * 0.20), floor(lake_h * 0.85));
                        add_ripple(drop_wx, strength * 0.85, mid, true);
                    }
                }
            }
        }

        // respawn
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
