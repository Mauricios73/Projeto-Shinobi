/// ========================================================
/// obj_environment_fx - DRAW
/// FASE 4.2
/// Iluminação Localizada + Atmosfera
/// ========================================================

if (!fx_enabled)
    exit;


// ========================================================
// CÂMERA
// ========================================================

var cam = view_camera[0];

var vx =
    camera_get_view_x(cam);

var vy =
    camera_get_view_y(cam);

var vw =
    camera_get_view_width(cam);

var vh =
    camera_get_view_height(cam);


// ========================================================
// TONALIDADE AMBIENTE
// ========================================================

if (ambient_alpha > 0)
{
    var weather = -1;

    if (instance_exists(obj_weather_manager))
    {
        weather =
            obj_weather_manager.weather_current;
    }


    switch (weather)
    {
        case obj_weather_manager.WEATHER_CLOUDY:

            draw_set_color(
                make_color_rgb(
                    150,
                    160,
                    175
                )
            );

        break;


        case obj_weather_manager.WEATHER_RAIN:

            draw_set_color(
                make_color_rgb(
                    90,
                    110,
                    145
                )
            );

        break;


        case obj_weather_manager.WEATHER_STORM:

            draw_set_color(
                make_color_rgb(
                    55,
                    65,
                    90
                )
            );

        break;


        case obj_weather_manager.WEATHER_SNOW:

            draw_set_color(
                make_color_rgb(
                    180,
                    195,
                    215
                )
            );

        break;


        default:

            draw_set_color(c_black);

        break;
    }


    draw_set_alpha(
        ambient_alpha
    );


    draw_rectangle(
        vx,
        vy,
        vx + vw,
        vy + vh,
        false
    );
}


// ========================================================
// ESCURECIMENTO
// ========================================================

if (darkness_alpha > 0)
{
    draw_set_color(c_black);

    draw_set_alpha(
        darkness_alpha
    );


    draw_rectangle(
        vx,
        vy,
        vx + vw,
        vy + vh,
        false
    );
}


// ========================================================
// ATMOSFERA / NÉVOA
// ========================================================

if (fog_alpha > 0)
{
    draw_set_color(
        make_color_rgb(
            120,
            135,
            155
        )
    );

    draw_set_alpha(
        fog_alpha
    );


    draw_rectangle(
        vx,
        vy,
        vx + vw,
        vy + vh,
        false
    );
}

// ========================================================
// COLOR GRADING
// ========================================================

if (color_alpha > 0)
{
    var grading_color =
        make_color_rgb(
            clamp(color_r * 255, 0, 255),
            clamp(color_g * 255, 0, 255),
            clamp(color_b * 255, 0, 255)
        );


    draw_set_color(
        grading_color
    );


    draw_set_alpha(
        color_alpha
    );


    draw_rectangle(
        vx,
        vy,
        vx + vw,
        vy + vh,
        false
    );
}

// ========================================================
// RELÂMPAGO — HALO EXTERNO
// ========================================================

if (lightning_halo_alpha > 0)
{
    var radius =
        lightning_radius;

    var steps = 8;


    for (var i = steps; i >= 1; i--)
    {
        var ratio =
            i / steps;

        var r =
            radius * ratio;


        var alpha =
            lightning_halo_alpha *
            (1 - ratio) *
            0.45;


        if (alpha <= 0)
            continue;


        draw_set_color(
            make_color_rgb(
                170,
                190,
                225
            )
        );

        draw_set_alpha(
            alpha
        );


        draw_circle(
            lightning_x,
            lightning_y,
            r,
            false
        );
    }
}


// ========================================================
// RELÂMPAGO — ILUMINAÇÃO LOCAL
// ========================================================

if (lightning_core_alpha > 0)
{
    var local_radius =
        lightning_radius * 0.65;


    draw_set_color(
        make_color_rgb(
            215,
            225,
            255
        )
    );


    draw_set_alpha(
        lightning_core_alpha * 0.22
    );


    draw_circle(
        lightning_x,
        lightning_y,
        local_radius,
        false
    );
}


// ========================================================
// RELÂMPAGO — FLASH GLOBAL SUAVE
// ========================================================

if (lightning_core_alpha > 0)
{
    draw_set_color(c_white);

    draw_set_alpha(
        lightning_core_alpha * 0.10
    );


    draw_rectangle(
        vx,
        vy,
        vx + vw,
        vy + vh,
        false
    );
}


// ========================================================
// RESET
// ========================================================

draw_set_alpha(1);

draw_set_color(c_white);