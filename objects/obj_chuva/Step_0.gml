var cam = view_camera[0];
var w   = camera_get_view_width(cam);
var h   = camera_get_view_height(cam);
var vx  = camera_get_view_x(cam);
var vy  = camera_get_view_y(cam);

if (w <= 1) w = camera_get_view_width(view_camera[0]);
if (h <= 1) h = camera_get_view_height(view_camera[0]);

// ---------- INIT (só cria arrays uma vez / quando muda a view) ----------
if (!init || w != gw || h != gh)
{
    init = true;
    gw = w;
    gh = h;

    rx = array_create(rain_max);
    ry = array_create(rain_max);
    rv = array_create(rain_max);
    rl = array_create(rain_max);
    ra = array_create(rain_max);
    ph = array_create(rain_max);

    for (var i = 0; i < rain_max; i++)
    {
        rx[i] = random(gw);
        ry[i] = random_range(safe_top, gh);
        rv[i] = random_range(10, 18);
        rl[i] = irandom_range(10, 22);
        ra[i] = random_range(0.10, 0.26);
        ph[i] = irandom(999999);
    }
}

// ---------- INTENSIDADE (roda todo step) ----------
var pm = (instance_exists(obj_weather_manager) ? obj_weather_manager.precip_mode : 0);

// 3 = fraca, 2 = forte
var target = (pm == 3) ? 120 : 320;
rain_active = clamp(round(lerp(rain_active, target, 0.08)), 0, rain_max);

// vento
var wind = wind_base + sin(current_time * wind_speed) * wind_amp;

// chances de ripple dependendo da intensidade
var ripple_chance = (pm == 3) ? 28 : 45;
var mid_chance    = (pm == 3) ? 50 : 70;

// ---------- MOVE (só as gotas ativas) ----------
for (var i = 0; i < rain_active; i++)
{
    var wx = wind + sin((current_time + ph[i]) * 0.002) * 0.6;

    rx[i] += wx;
    ry[i] += rv[i];

    // hit na água
    if (variable_global_exists("lake_gui_top") && ry[i] >= global.lake_gui_top)
    {
        if (irandom(99) < ripple_chance && instance_exists(obj_lake_v3))
        {
            var drop_wx = vx + rx[i];

            with (obj_lake_v3)
            {
                if (irandom(99) < mid_chance)
                {
                    var mid = irandom_range(floor(lake_h * 0.20), floor(lake_h * 0.85));
                    add_ripple(drop_wx, 0.85, mid, true);
                }
            }
        }

        // respawn
        ry[i] = -20;
        rx[i] = random(gw);
        continue;
    }

    // respawn fora da tela
    if (ry[i] > gh + 20)
    {
        ry[i] = -20;
        rx[i] = random(gw);
    }

    if (rx[i] > gw + 20) rx[i] = -20;
    if (rx[i] < -20)     rx[i] = gw + 20;
}