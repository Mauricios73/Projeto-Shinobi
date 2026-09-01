/// ========================================================
/// OBJ_FOG
/// DRAW END GUI
/// FASE 4.6 - ATMOSFERA
/// ========================================================


// ========================================================
// DIMENSÕES DA GUI
// ========================================================

var current_gui_w =
    display_get_gui_width();

var current_gui_h =
    display_get_gui_height();


// ========================================================
// RECRIAR SURFACE SE NECESSÁRIO
// ========================================================

if (
    !surface_exists(surf_fog) ||
    surface_get_width(surf_fog) != current_gui_w ||
    surface_get_height(surf_fog) != current_gui_h
)
{
    if (surface_exists(surf_fog))
    {
        surface_free(surf_fog);
    }


    surf_fog =
        surface_create(
            current_gui_w,
            current_gui_h
        );
}


// ========================================================
// FOG BASE
// ========================================================

surface_set_target(
    surf_fog
);

draw_clear_alpha(
    c_black,
    0
);


var t =
    current_time *
    fog_speed;


// ========================================================
// CAMADAS
// ========================================================

for (var l = 0; l < fog_layers; l++)
{
    var layer_alpha =
        0.05 +
        l * 0.03;


    var offset =
        t *
        (10 + l * 15);


    draw_set_alpha(
        layer_alpha
    );


    for (var i = 0; i < 20; i++)
    {
        var xx =
            frac(
                i * 0.17 +
                offset
            ) *
            surface_get_width(
                surf_fog
            );


        var yy =
            (i * 37 mod
            surface_get_height(
                surf_fog
            ));


        draw_circle(
            xx,
            yy,
            30 + l * 20,
            false
        );
    }
}


surface_reset_target();


// ========================================================
// DESENHAR SURFACE
// ========================================================

gpu_set_texfilter(true);

draw_surface_stretched(
    surf_fog,
    0,
    0,
    current_gui_w,
    current_gui_h
);

gpu_set_texfilter(false);


draw_set_alpha(1);


// ========================================================
// HAZE ATMOSFÉRICO
// ========================================================

if (
    atmosphere_enabled &&
    haze_amount > 0.01
)
{
    var cam =
        view_camera[0];


    var vx =
        camera_get_view_x(cam);

    var vy =
        camera_get_view_y(cam);

    var vw =
        camera_get_view_width(cam);

    var vh =
        camera_get_view_height(cam);


    var haze_wave =
        sin(atmosphere_time) *
        0.02;


    var haze_alpha =
        clamp(
            haze_amount +
            haze_wave,
            0,
            1
        );


    draw_set_color(
        make_color_rgb(
            150,
            160,
            170
        )
    );


    draw_set_alpha(
        haze_alpha
    );


    draw_rectangle(
        vx,
        vy + vh * 0.35,
        vx + vw,
        vy + vh,
        false
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}


// ========================================================
// PROFUNDIDADE ATMOSFÉRICA
// ========================================================

if (
    atmosphere_enabled &&
    depth_amount > 0.01
)
{
    var cam2 =
        view_camera[0];


    var vx2 =
        camera_get_view_x(cam2);

    var vy2 =
        camera_get_view_y(cam2);

    var vw2 =
        camera_get_view_width(cam2);

    var vh2 =
        camera_get_view_height(cam2);


    draw_set_color(
        make_color_rgb(
            120,
            135,
            150
        )
    );


    draw_set_alpha(
        depth_amount * 0.20
    );


    draw_rectangle(
        vx2,
        vy2,
        vx2 + vw2,
        vy2 + vh2 * 0.35,
        false
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}