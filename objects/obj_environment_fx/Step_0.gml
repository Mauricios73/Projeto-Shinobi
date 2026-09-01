/// ========================================================
/// obj_environment_fx - STEP
/// FASE 4.2
/// Relâmpago + Iluminação Localizada + Atmosfera
/// ========================================================

if (!fx_enabled)
    exit;


var dt = 1 / room_speed;


// ========================================================
// WEATHER MANAGER
// ========================================================

if (!instance_exists(obj_weather_manager))
    exit;

var wm = obj_weather_manager;

var weather = wm.weather_current;

var intensity =
    clamp(
        wm.weather_intensity,
        0,
        1
    );


// ========================================================
// AMBIENTE INTERNO
// ========================================================

var indoor = false;

if (variable_global_exists("environment"))
{
    if (variable_struct_exists(
        global.environment,
        "weather"
    ))
    {
        indoor =
            global.environment.weather.indoor;
    }
}


// ========================================================
// ILUMINAÇÃO BASE
// ========================================================

switch (weather)
{
    case wm.WEATHER_CLEAR:

        ambient_target = 0;
        darkness_target = 0;

    break;


    case wm.WEATHER_CLOUDY:

        ambient_target = 0.05;
        darkness_target = 0.04;

    break;


    case wm.WEATHER_RAIN:

        ambient_target =
            0.10 * intensity;

        darkness_target =
            0.08 * intensity;

    break;


    case wm.WEATHER_STORM:

        ambient_target =
            0.20 * intensity;

        darkness_target =
            0.18 * intensity;

    break;


    case wm.WEATHER_SNOW:

        ambient_target = 0.06;
        darkness_target = 0.03;

    break;
}


// ========================================================
// INTERIOR
// ========================================================

if (indoor)
{
    ambient_target *= 0.35;
    darkness_target *= 0.25;
}


// ========================================================
// TRANSIÇÕES
// ========================================================

ambient_alpha =
    lerp(
        ambient_alpha,
        ambient_target,
        0.06
    );

darkness_alpha =
    lerp(
        darkness_alpha,
        darkness_target,
        0.06
    );


// ========================================================
// ATMOSFERA DA TEMPESTADE
// ========================================================

if (
    weather == wm.WEATHER_STORM
    &&
    !indoor
)
{
    storm_atmosphere =
        lerp(
            storm_atmosphere,
            intensity,
            0.03
        );
}
else
{
    storm_atmosphere =
        lerp(
            storm_atmosphere,
            0,
            0.03
        );
}


// ========================================================
// NÉVOA ATMOSFÉRICA
// ========================================================

fog_target =
    storm_atmosphere *
    random_range(
        fog_min_alpha,
        fog_max_alpha
    );

fog_alpha =
    lerp(
        fog_alpha,
        fog_target,
        0.015
    );


// ========================================================
// RELÂMPAGO
// ========================================================

if (
    weather == wm.WEATHER_STORM
    &&
    !indoor
)
{
    lightning_timer -= dt;


    // ----------------------------------------------------
    // INICIAR RELÂMPAGO
    // ----------------------------------------------------

    if (
        lightning_timer <= 0
        &&
        !lightning_active
    )
    {
        lightning_active = true;

        lightning_phase = 0;

        lightning_strength =
            random_range(
                0.65,
                1.0
            );

        lightning_count += 1;


        // ------------------------------------------------
        // POSIÇÃO NA CÂMERA
        // ------------------------------------------------

        var cam = view_camera[0];

        var vx =
            camera_get_view_x(cam);

        var vy =
            camera_get_view_y(cam);

        var vw =
            camera_get_view_width(cam);

        var vh =
            camera_get_view_height(cam);


        // Relâmpago aparece no céu.
        lightning_x =
            vx +
            random_range(
                vw * 0.15,
                vw * 0.85
            );

        lightning_y =
            vy +
            random_range(
                vh * 0.05,
                vh * 0.30
            );


        // ------------------------------------------------
        // TAMANHO DA LUZ
        // ------------------------------------------------

        lightning_radius =
            random_range(
                vw * 0.18,
                vw * 0.35
            );

        lightning_radius_target =
            lightning_radius;


        // ------------------------------------------------
        // TROVÃO
        // ------------------------------------------------

        thunder_pending = true;

        thunder_timer =
            random_range(
                thunder_min_delay,
                thunder_max_delay
            );

        thunder_strength =
            lightning_strength;
    }
}
else
{
    lightning_active = false;

    lightning_alpha = 0;

    lightning_core_alpha = 0;
    lightning_halo_alpha = 0;

    thunder_pending = false;
    thunder_timer = 0;

    lightning_timer =
        random_range(
            lightning_min_time,
            lightning_max_time
        );
}


// ========================================================
// ANIMAÇÃO DO RELÂMPAGO
// ========================================================

if (lightning_active)
{
    lightning_phase += dt;


    // ----------------------------------------------------
    // FLASH 1
    // ----------------------------------------------------

    if (lightning_phase < 0.045)
    {
        lightning_core_alpha =
            lightning_strength;

        lightning_halo_alpha =
            lightning_strength * 0.70;
    }


    // ----------------------------------------------------
    // QUEDA
    // ----------------------------------------------------

    else if (lightning_phase < 0.10)
    {
        lightning_core_alpha =
            lightning_strength * 0.18;

        lightning_halo_alpha =
            lightning_strength * 0.35;
    }


    // ----------------------------------------------------
    // FLASH 2
    // ----------------------------------------------------

    else if (lightning_phase < 0.16)
    {
        lightning_core_alpha =
            lightning_strength * 0.72;

        lightning_halo_alpha =
            lightning_strength * 0.55;
    }


    // ----------------------------------------------------
    // QUEDA
    // ----------------------------------------------------

    else if (lightning_phase < 0.28)
    {
        lightning_core_alpha =
            lightning_strength * 0.08;

        lightning_halo_alpha =
            lightning_strength * 0.15;
    }


    // ----------------------------------------------------
    // FINAL
    // ----------------------------------------------------

    else
    {
        lightning_core_alpha = 0;
        lightning_halo_alpha = 0;

        lightning_active = false;

        lightning_timer =
            random_range(
                lightning_min_time,
                lightning_max_time
            );
    }


    lightning_alpha =
        lightning_core_alpha;
}


// ========================================================
// TROVÃO
// ========================================================

if (thunder_pending)
{
    thunder_timer -= dt;


    if (thunder_timer <= 0)
    {
        thunder_pending = false;


        var thunder_sound = -1;

        var roll = irandom(2);


        switch (roll)
        {
            case 0:

                thunder_sound =
                    snd_thunder_dark01;

            break;


            case 1:

                thunder_sound =
                    snd_thunder_dark02;

            break;


            case 2:

                thunder_sound =
                    snd_thunder_loud_dark_01;

            break;
        }


        if (thunder_sound != -1)
        {
            var thunder_handle =
                audio_play_sound(
                    thunder_sound,
                    4,
                    false
                );


            audio_sound_gain(
                thunder_handle,
                clamp(
                    thunder_strength,
                    0.35,
                    1
                ),
                0
            );
        }
    }
}

// ========================================================
// COLOR GRADING
// ========================================================

var grading_r = 1;
var grading_g = 1;
var grading_b = 1;

var grading_alpha = 0;


// ========================================================
// PERFIL CLIMÁTICO
// ========================================================

switch (weather)
{
    case wm.WEATHER_CLEAR:

        grading_r = 1.00;
        grading_g = 0.99;
        grading_b = 0.96;

        grading_alpha = 0.025;

    break;


    case wm.WEATHER_CLOUDY:

        grading_r = 0.88;
        grading_g = 0.92;
        grading_b = 1.00;

        grading_alpha = 0.08;

    break;


    case wm.WEATHER_RAIN:

        grading_r = 0.72;
        grading_g = 0.82;
        grading_b = 1.00;

        grading_alpha =
            0.08 +
            (0.08 * intensity);

    break;


    case wm.WEATHER_STORM:

        grading_r = 0.55;
        grading_g = 0.65;
        grading_b = 0.90;

        grading_alpha =
            0.12 +
            (0.15 * intensity);

    break;


    case wm.WEATHER_SNOW:

        grading_r = 0.90;
        grading_g = 0.95;
        grading_b = 1.00;

        grading_alpha = 0.08;

    break;
}


// ========================================================
// INTERIOR
// ========================================================

if (indoor)
{
    grading_alpha *= 0.35;
}


// ========================================================
// TRANSIÇÃO
// ========================================================

target_color_r = grading_r;
target_color_g = grading_g;
target_color_b = grading_b;

target_color_alpha = grading_alpha;


color_r = lerp(
    color_r,
    target_color_r,
    color_transition_speed
);

color_g = lerp(
    color_g,
    target_color_g,
    color_transition_speed
);

color_b = lerp(
    color_b,
    target_color_b,
    color_transition_speed
);

color_alpha = lerp(
    color_alpha,
    target_color_alpha,
    color_transition_speed
);

// ========================================================
// ESTADO GLOBAL
// ========================================================

global.environment.visual = {
    ambient_alpha: ambient_alpha,
    darkness_alpha: darkness_alpha,
    fog_alpha: fog_alpha,
    lightning: lightning_alpha,
    lightning_x: lightning_x,
    lightning_y: lightning_y,
    lightning_radius: lightning_radius,
    lightning_count: lightning_count,
    thunder_pending: thunder_pending
};