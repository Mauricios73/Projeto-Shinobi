if (!surface_exists(application_surface)) exit;

var cam = view_camera[0];
var vx  = camera_get_view_x(cam);
var vy  = camera_get_view_y(cam);
var vw  = camera_get_view_width(cam);
var vh  = camera_get_view_height(cam);

// --------------------
// Lago em WORLD (x,y = centro)
var leftW = x - w * 0.50;
var topW  = y - h * 0.50;

// Lago em SCREEN/GUI (isso é o que importa no Draw GUI End)
var left = leftW - vx;
var top  = topW  - vy;

// --------------------
// Refletir "do chão até o topo": captura do topo da view até a linha d'água
var src_h = clamp(top, 1, vh); // top é y da água na tela
var k     = src_h / h;         // mapeamento source->dest

// Cria/recria surface do reflexo (altura = src_h)
if (!surface_exists(surf_reflect)
|| surface_get_width(surf_reflect)  != w
|| surface_get_height(surf_reflect) != src_h)
{
    if (surface_exists(surf_reflect)) surface_free(surf_reflect);
    surf_reflect = surface_create(w, src_h);
}

// --------------------
// 1) Monta o reflexo numa surface
// --------------------
surface_set_target(surf_reflect);
draw_clear_alpha(c_black, 0);

// Região da TELA que vamos capturar: src_h acima da água
var sx = left;
var sy = top - src_h;
var sw = w;
var sh = src_h;

// Clipping simples pra não estourar fora da view
var dx = 0;
var dy = 0;

if (sx < 0) { dx = -sx; sw += sx; sx = 0; }
if (sy < 0) { dy = -sy; sh += sy; sy = 0; }
if (sx + sw > vw) sw = vw - sx;
if (sy + sh > vh) sh = vh - sy;

// Copia da application_surface e espelha verticalmente
if (sw > 0 && sh > 0)
{
    draw_surface_part_ext(application_surface, sx, sy, sw, sh,
                          dx, dy + sh, 1, -1, c_white, 1);
}

surface_reset_target();

// --------------------
// 2) Desenha o reflexo com distorção (fatias)
// --------------------
var t = current_time * wave_speed;

for (var yy = 0; yy < h; yy += slice_h)
{
    // Se quiser inverter a direção da ONDA, use: -sin(...)
    var off = sin(t + yy * wave_freq) * wave_amp;

    // fade (mais Kingdom)
    var depthFade = 1 - (yy / h) * 0.35;
    var a_ref = reflect_alpha * depthFade;

    // Mapeia yy (dest) -> src_y (source)
    var src_y     = floor(yy * k);
    var src_slice = max(1, ceil(slice_h * k));
    if (src_y + src_slice > src_h) src_slice = max(1, src_h - src_y);

    // Ajusta escala vertical pra caber no slice_h do lago
    var yscale = slice_h / src_slice;

    draw_surface_part_ext(surf_reflect, 0, src_y, w, src_slice,
                          left + off, top + yy, 1, yscale, c_white, a_ref);
}

// --------------------
// 3) “Tinta” de água por cima
// --------------------
draw_set_alpha(0.22);
draw_set_color(make_color_rgb(25, 55, 75));
draw_rectangle(left, top, left + w, top + h, false);

// --------------------
// 4) Espuma (pixels brancos)
// --------------------
draw_set_color(c_white);

for (var i = 0; i < foam_n; i++)
{
    var a = 0.12 + 0.25 * abs(sin((current_time + foam_phase[i]) * 0.004));
    draw_set_alpha(a);

    var fx = left + foam_x[i];
    var fy = top  + foam_y[i];

    fx += sin(t * 2 + fy * 0.07) * 1.2;

    draw_rectangle(fx, fy, fx + 2, fy + 1, false);
}

// Reset
draw_set_alpha(1);
draw_set_color(c_white);
