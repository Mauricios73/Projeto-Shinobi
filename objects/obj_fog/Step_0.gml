/// ========================================================
/// OBJ_FOG
/// STEP
/// ========================================================


// ========================================================
// CÂMERA
// ========================================================

var cam =
    view_camera[0];

var camx =
    camera_get_view_x(cam);

var camy =
    camera_get_view_y(cam);

var camw =
    camera_get_view_width(cam);

var camh =
    camera_get_view_height(cam);


// ========================================================
// HORIZONTE
// ========================================================

var target_ratio_y =
    camh * 0.52;

if (instance_exists(obj_env))
{
    target_ratio_y =
        camh *
        obj_env.ground_cut_ratio;
}


// ========================================================
// POSIÇÃO REAL DO LAGO
// ========================================================

var lago_y =
    camy +
    target_ratio_y;


// Ajuste vertical existente
var offset_ajuste = 250;

lago_y +=
    offset_ajuste;


// ========================================================
// VERIFICAR WEATHER MANAGER
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
// EMISSÃO DO FOG
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


    // ----------------------------------------------------
    // Emissão aleatória
    // ----------------------------------------------------

    if (irandom(15) == 0)
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
    // ----------------------------------------------------
    // Quando todas as partículas desaparecerem,
    // o objeto pode ser destruído.
    // ----------------------------------------------------

    if (part_particles_count(fog_sys) == 0)
    {
        instance_destroy();
        exit;
    }
}


// ========================================================
// FASE 4.6
// ATMOSFERA AVANÇADA
// ========================================================

if (
    atmosphere_enabled &&
    instance_exists(obj_weather_manager)
)
{
    var wm =
        obj_weather_manager;


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
        case wm.WEATHER_CLEAR:

            atmosphere_target = 0.05;
            haze_target = 0.02;
            depth_target = 0.05;

        break;


        case wm.WEATHER_CLOUDY:

            atmosphere_target = 0.18;
            haze_target = 0.12;
            depth_target = 0.20;

        break;


        case wm.WEATHER_RAIN:

            atmosphere_target =
                0.20 +
                intensity * 0.12;

            haze_target =
                0.15 +
                intensity * 0.10;

            depth_target =
                0.25 +
                intensity * 0.15;

        break;


        case wm.WEATHER_STORM:

            atmosphere_target =
                0.30 +
                intensity * 0.20;

            haze_target =
                0.25 +
                intensity * 0.20;

            depth_target =
                0.40 +
                intensity * 0.25;

        break;


        case wm.WEATHER_SNOW:

            atmosphere_target =
                0.16 +
                intensity * 0.10;

            haze_target =
                0.12 +
                intensity * 0.08;

            depth_target =
                0.22 +
                intensity * 0.10;

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


    atmosphere_time +=
        0.01;
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