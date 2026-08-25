var cam = view_camera[0];
var w   = camera_get_view_width(cam);
var h   = camera_get_view_height(cam);
var vx  = camera_get_view_x(cam);
var vy  = camera_get_view_y(cam);

if (w <= 1) w = camera_get_view_width(view_camera[0]);
if (h <= 1) h = camera_get_view_height(view_camera[0]);

// ---------- INIT ----------
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

// ---------- INTENSIDADE REAL DO WEATHER SYSTEM ----------
var pm = 0;
var wi = 0;
var transitioning = false;

if (instance_exists(obj_weather_manager))
{
    pm = obj_weather_manager.precip_mode;
    wi = clamp(obj_weather_manager.weather_intensity, 0, 1);
    transitioning = obj_weather_manager.weather_transitioning;
}

// A quantidade visual acompanha a intensidade contínua.
// CLEAR/CLOUDY = 0, RAIN = ~240, STORM = ~420.
var target = 0;
if (pm == 3) target = round(lerp(0, 240, clamp(wi / 0.65, 0, 1)));
else if (pm == 2) target = round(lerp(240, 420, clamp((wi - 0.65) / 0.35, 0, 1)));
else if (pm == 1) target = 0;

// Em uma transicao para CLEAR, permite desaparecer suavemente.
// Quando o Weather System conclui CLEAR, o manager destrói esta instancia.
rain_active = clamp(round(lerp(rain_active, target, 0.12)), 0, rain_max);

// vento
var wind = wind_base + sin(current_time * wind_speed) * wind_amp;

// ripple acompanha a intensidade atual da chuva.
var rain_strength = clamp(wi, 0, 1);
var ripple_chance = clamp(round(18 + rain_strength * 42), 0, 60);
var mid_chance = clamp(round(35 + rain_strength * 45), 0, 85);

// ---------- MOVE ----------
for (var i = 0; i < rain_active; i++)
{
    var wx = wind + sin((current_time + ph[i]) * 0.002) * 0.6;

    rx[i] += wx;
    ry[i] += rv[i];

    // hit na agua
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

        ry[i] = -20;
        rx[i] = random(gw);
        continue;
    }

    if (ry[i] > gh + 20)
    {
        ry[i] = -20;
        rx[i] = random(gw);
    }

    if (rx[i] > gw + 20) rx[i] = -20;
    if (rx[i] < -20) rx[i] = gw + 20;
}

// Segurança: fora do clima de chuva, não deixa partículas residuais.
if (!transitioning && pm == 0 && rain_active <= 1) instance_destroy();
