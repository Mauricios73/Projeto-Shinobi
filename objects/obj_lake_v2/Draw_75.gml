if (!surface_exists(application_surface)) exit;

var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

var left = (guiW - w) * 0.5;
var top  = guiH - h;

// --------------------
// SURFACE REFLEXO
// --------------------
if (!surface_exists(surf_reflect)
|| surface_get_width(surf_reflect)  != w
|| surface_get_height(surf_reflect) != h)
{
    if (surface_exists(surf_reflect)) surface_free(surf_reflect);
    surf_reflect = surface_create(w, h);
}

// --------------------
// CAPTURA REFLEXO
// --------------------
surface_set_target(surf_reflect);
draw_clear_alpha(c_black, 0);

var sx = left;
var sy = top - h;

draw_surface_part_ext(application_surface,
                      sx, sy, w, h,
                      0, h,
                      1, -1,
                      c_white, 1);

surface_reset_target();

var t = current_time * wave_speed;

var calm_zone = 6;        // faixa totalmente parada
var build_zone = 40;      // onde a onda ganha força

for (var yy = 0; yy < h; yy += slice_h)
{
    // --------------------
    // 1️⃣ DISTÂNCIA REAL DA MARGEM
    // --------------------
    var shore_dist = yy;

    // normalizado 0 → 1
    var shore_norm = clamp(shore_dist / h, 0, 1);

    // --------------------
    // 2️⃣ PROFUNDIDADE VISUAL (curva suave)
    // --------------------
    var lake_depth = power(shore_norm, 1.6);

    // --------------------
    // 3️⃣ CALMARIA NA BORDA
    // --------------------
    var surface_calm;

    if (shore_dist < calm_zone)
    {
        surface_calm = 0;
    }
    else
    {
        var build = clamp((shore_dist - calm_zone) / build_zone, 0, 1);
        surface_calm = power(build, 1.4);
    }

    // --------------------
    // 4️⃣ ONDAS
    // --------------------
    var wave_main  = sin(t * 0.6 + yy * 0.045) * current_wave_amp;
    var wave_micro = sin(t * 1.8 + yy * 0.22) * (current_wave_amp * 0.35);

    // ruído fixo por linha
    var noise = frac(sin(yy * 12.9898) * 43758.5453);
    noise = (noise - 0.5);

    var inner_scroll = sin(t * 0.3 + yy * 0.02);

    var off = (wave_main + wave_micro) * surface_calm;
    off += noise * surface_calm * 2.0;
    off += inner_scroll * lake_depth * 1.5;

    // --------------------
    // 5️⃣ FADE REAL (começa na margem)
    // --------------------
    var fade = 1 - lake_depth * 0.7;

    // fade suave nos primeiros pixels
    var edge_fade = clamp((shore_dist - 2) / 6, 0, 1);

    var a_ref = reflect_alpha * fade * edge_fade;

    // --------------------
    // 6️⃣ COMPRESSÃO HORIZONTAL
    // --------------------
    var scale_x = 1 - lake_depth * 0.04;

    draw_surface_part_ext(
        surf_reflect,
        0, yy, w, slice_h,
        left + off,
        top + yy,
        scale_x, 1,
        c_white,
        a_ref
    );
}

// --------------------
// FADE NA BORDA (disfarça linha)
// --------------------
for (var i = 0; i < 8; i++)
{
    var a = 0.35 - (i * 0.04);
    draw_set_alpha(a);
    draw_set_color(make_color_rgb(10, 25, 40));
    draw_rectangle(left, top + i, left + w, top + i + 1, false);
}

draw_set_alpha(1);
draw_set_color(c_white);



// --------------------
// GRADIENTE DA ÁGUA
// --------------------
for (var yy = 0; yy < h; yy += 2)
{
    var depth_factor = yy / h;
    var dark = 0.22 + depth_factor * 0.25;

    draw_set_alpha(dark);
    draw_set_color(make_color_rgb(20, 45, 65));
    draw_rectangle(left, top + yy, left + w, top + yy + 2, false);
}

draw_set_alpha(1);
draw_set_color(c_white);

// --------------------
// ESPUMA
// --------------------
for (var i = 0; i < foam_n; i++)
{
    var a = 0.12 + 0.25 * abs(sin((current_time + foam_phase[i]) * 0.004));
    draw_set_alpha(a);

    var fx = left + foam_x[i];
    var fy = top  + foam_y[i];

    fx += sin(t * 2 + fy * 0.07) * 1.2;

    draw_rectangle(fx, fy, fx + 6, fy + 1, false);
}

// =============================
// DESENHA RIPPLES
// =============================
draw_set_color(c_white);

for (var i = 0; i < ripple_max; i++)
{
    if (ripple_a[i] > 0)
    {
        draw_set_alpha(ripple_a[i] * 0.4);

        var rx = left + ripple_x[i];
        var ry = top + ripple_y[i];

        draw_circle(rx, ry, ripple_r[i], false);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);

global.lake_gui_top = top;
global.lake_gui_h   = h;
