if (!surface_exists(application_surface)) exit;

// Tamanho da GUI (tela)
var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

// --------------------
// LAGO FIXO NA TELA
// Ajuste como você quiser:
var left = (guiW - w) * 0.5;   // centralizado
var top  = guiH - h; 


// encostado embaixo (linha d’água = top)

// --------------------
// Surface do reflexo (mesma altura do lago -> sem distorção)
if (!surface_exists(surf_reflect)
|| surface_get_width(surf_reflect)  != w
|| surface_get_height(surf_reflect) != h)
{
    if (surface_exists(surf_reflect)) surface_free(surf_reflect);
    surf_reflect = surface_create(w, h);
}

// --------------------
// 1) Monta o reflexo na surface
// Captura EXATAMENTE h pixels acima da água (espelho 1:1)
// --------------------
surface_set_target(surf_reflect);
draw_clear_alpha(c_black, 0);

// região da TELA a capturar (screen coords)
var sx = left;
var sy = top - h;
var sw = w;
var sh = h;

// clamp simples dentro da view (que é 1366x768 no seu setup)
var vw = camera_get_view_width(view_camera[0]);
var vh = camera_get_view_height(view_camera[0]);

var dx = 0;
var dy = 0;

if (sx < 0) { dx = -sx; sw += sx; sx = 0; }
if (sy < 0) { dy = -sy; sh += sy; sy = 0; }
if (sx + sw > vw) sw = vw - sx;
if (sy + sh > vh) sh = vh - sy;

if (sw > 0 && sh > 0)
{
    // espelha vertical (yscale = -1)
    draw_surface_part_ext(application_surface, sx, sy, sw, sh,
                          dx, dy + sh, 1, -1, c_white, 1);
}

surface_reset_target();

// --------------------
// 2) Desenha o reflexo com ondas (sem distorção vertical)
// --------------------
var t = current_time * wave_speed;

for (var yy = 0; yy < h; yy += slice_h)
{
    // Se a onda estiver indo “pro lado errado”, inverta o sinal:
    // var off = -sin(...)
    var off = sin(t + yy * wave_freq) * wave_amp;

    // Fade conforme desce
    var depthFade = 1 - (yy / h) * 0.40;
    var a_ref = reflect_alpha * depthFade;

    draw_surface_part_ext(surf_reflect, 0, yy, w, slice_h,
                          left + off, top + yy, 1, 1, c_white, a_ref);
}

// --------------------
// 3) Tinta da água por cima
// --------------------
draw_set_alpha(0.22);
draw_set_color(make_color_rgb(25, 55, 75));
draw_rectangle(left, top, left + w, top + h, false);

// --------------------
// 4) Espuma
// --------------------
draw_set_color(c_white);
for (var i = 0; i < foam_n; i++)
{
    var a = 0.12 + 0.25 * abs(sin((current_time + foam_phase[i]) * 0.004));
    draw_set_alpha(a);

    var fx = left + foam_x[i];
    var fy = top  + foam_y[i];

    fx += sin(t * 2 + fy * 0.07) * 1.2;

    draw_rectangle(fx, fy, fx + 5, fy + 2, false);

}

draw_set_alpha(1);
draw_set_color(c_white);

global.lake_gui_top = top; // linha d'água (top do lago)
global.lake_gui_h   = h;   // altura do lago
