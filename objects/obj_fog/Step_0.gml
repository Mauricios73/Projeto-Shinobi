
/// ========================================================
/// OBJ_FOG
/// STEP
/// FASE 4.6 - ATMOSFERA AVANÇADA
/// ========================================================


// ========================================================
// CÂMERA
// ========================================================

var cam = view_camera[0];

var camx = camera_get_view_x(cam);
var camy = camera_get_view_y(cam);
var camw = camera_get_view_width(cam);
var camh = camera_get_view_height(cam);


// ========================================================
// HORIZONTE
// ========================================================

var target_ratio_y = camh * 0.52;

if (instance_exists(obj_env))
{
    target_ratio_y =
        camh * obj_env.ground_cut_ratio;
}


// ========================================================
// POSIÇÃO REAL DO LAGO
// ========================================================

var lago_y =
    camy + target_ratio_y;


// Ajuste vertical existente
var offset_ajuste = 250;

lago_y += offset_ajuste;


// ========================================================
// WEATHER MANAGER
// ========================================================

if (instance_exists(obj_weather_manager))
{
    if (!obj_weather_manager.fog_on)
    {
        is_fading_out = true;
    }
    else
    {
        is_fading_out = false;
    }
}


// ========================================================
// EMISSÃO DO FOG DISTANTE
// ========================================================

if (!is_fading_out)
{
    var y_min =
        lago_y - 115;

    var y_max =
        lago_y + 5;


    part_emitter_region(
        fog_sys,
        fog_emit,
        camx - 200,
        camx + camw + 200,
        y_min,
        y_max,
        ps_shape_rectangle,
        ps_distr_linear
    );


    // Emissão mais espaçada
    if (irandom(20) == 0)
    {
        part_emitter_burst(
            fog_sys,
            fog_emit,
            fog_type,
            irandom_range(1, 2)
        );
    }
}
else
{
    if (part_particles_count(fog_sys) == 0)
    {
        instance_destroy();
        exit;
    }
}


// ========================================================
// ATMOSFERA AVANÇADA
// ========================================================

if (
    atmosphere_enabled &&
    instance_exists(obj_weather_manager)
)
{
    var wm = obj_weather_manager;

    var weather =
        wm.weather_current;

    var intensity =
        clamp(
            wm.weather_intensity,
            0,
            1
        );


    // ====================================================
    // ALVOS ATMOSFÉRICOS
    // ====================================================

    switch (weather)
    {
        // ------------------------------------------------
        // CÉU LIMPO
        // ------------------------------------------------

        case wm.WEATHER_CLEAR:

            atmosphere_target = 0.025;
            haze_target = 0.01;
            depth_target = 0.025;

        break;


        // ------------------------------------------------
        // NUBLADO
        // ------------------------------------------------

        case wm.WEATHER_CLOUDY:

            atmosphere_target = 0.07;
            haze_target = 0.035;
            depth_target = 0.08;

        break;


        // ------------------------------------------------
        // CHUVA
        // ------------------------------------------------

        case wm.WEATHER_RAIN:

            atmosphere_target =
                0.08 +
                intensity * 0.05;

            haze_target =
                0.04 +
                intensity * 0.04;

            depth_target =
                0.10 +
                intensity * 0.08;

        break;


        // ------------------------------------------------
        // TEMPESTADE
        // ------------------------------------------------

        case wm.WEATHER_STORM:

            atmosphere_target =
                0.12 +
                intensity * 0.08;

            haze_target =
                0.06 +
                intensity * 0.06;

            depth_target =
                0.16 +
                intensity * 0.10;

        break;


        // ------------------------------------------------
        // NEVE
        // ------------------------------------------------

        case wm.WEATHER_SNOW:

            atmosphere_target =
                0.07 +
                intensity * 0.05;

            haze_target =
                0.04 +
                intensity * 0.03;

            depth_target =
                0.09 +
                intensity * 0.06;

        break;
    }


    // ====================================================
    // TRANSIÇÕES
    // ====================================================

    atmosphere_amount =
        lerp(
            atmosphere_amount,
            atmosphere_target,
            atmosphere_speed
        );


    haze_amount =
        lerp(
            haze_amount,
            haze_target,
            atmosphere_speed
        );


    depth_amount =
        lerp(
            depth_amount,
            depth_target,
            atmosphere_speed
        );


    // ====================================================
    // TEMPO
    // ====================================================

    atmosphere_time += 0.01;
}


// ========================================================
// INTERIOR
// ========================================================

if (
    variable_global_exists("environment") &&
    variable_struct_exists(
        global.environment,
        "weather"
    )
)
{
    if (
        global.environment.weather.indoor
    )
    {
        atmosphere_amount *= 0.20;
        haze_amount *= 0.10;
        depth_amount *= 0.15;
    }
}


// ========================================================
// NEVOEIRO MÓVEL
// ========================================================

mist_wave += 0.008;


// ========================================================
// MÁQUINA DE ESTADOS
// ========================================================

switch (mist_state)
{
    // ====================================================
    // ESPERANDO
    // ====================================================

    case 0:

        mist_timer--;

        mist_alpha =
            lerp(
                mist_alpha,
                0,
                0.05
            );


        if (mist_timer <= 0)
        {
            mist_state = 1;

            mist_x =
                camx - 350;


            mist_y =
                random_range(
                    camy + camh * 0.40,
                    camy + camh * 0.68
                );


            mist_speed =
                random_range(
                    0.25,
                    0.45
                );


            mist_alpha = 0;


            mist_target_alpha =
                random_range(
                    0.08,
                    0.14
                );


            mist_scale_x =
                random_range(
                    2.0,
                    3.2
                );


            mist_scale_y =
                random_range(
                    0.55,
                    0.90
                );
        }

    break;


    // ====================================================
    // ENTRANDO
    // ====================================================

    case 1:

        mist_x += mist_speed;


        mist_alpha =
            lerp(
                mist_alpha,
                mist_target_alpha,
                0.015
            );


        mist_y +=
            sin(mist_wave) *
            0.15;


        if (
            mist_x >
            camx + camw * 0.20
        )
        {
            mist_state = 2;
        }

    break;


    // ====================================================
    // ATRAVESSANDO
    // ====================================================

    case 2:

        mist_x += mist_speed;


        mist_y +=
            sin(mist_wave) *
            0.18;


        mist_alpha =
            lerp(
                mist_alpha,
                mist_target_alpha,
                0.01
            );


        if (
            mist_x >
            camx + camw * 0.65
        )
        {
            mist_state = 3;
        }

    break;


    // ====================================================
    // DESAPARECENDO
    // ====================================================

    case 3:

        mist_x += mist_speed;


        mist_alpha =
            lerp(
                mist_alpha,
                0,
                0.018
            );


        mist_y +=
            sin(mist_wave) *
            0.20;


        if (
            mist_alpha < 0.005 ||
            mist_x > camx + camw + 350
        )
        {
            mist_alpha = 0;

            mist_state = 0;

            mist_timer =
                random_range(
                    180,
                    500
                );
        }

    break;
}