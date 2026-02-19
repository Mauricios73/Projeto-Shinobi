///// obj_boot - Draw GUI
//var gw = display_get_gui_width();
//var gh = display_get_gui_height();

//// Fundo preto total
//draw_set_color(bg_col);
//draw_set_alpha(1);
//draw_rectangle(0, 0, gw, gh, false);

//// Se índice inválido, não desenha mais nada
//if (idx >= array_length(seq)) exit;

//var spr = seq[idx].spr;
//if (spr == -1) exit;

//// Anti-blur (importante p/ pixel art)
//gpu_set_texfilter(false);

//// Calcula escala pra caber na tela com margem
//var maxW = gw * (1 - margin * 2);
//var maxH = gh * (1 - margin * 2);

//var sw = sprite_get_width(spr);
//var sh = sprite_get_height(spr);

//var sc = min(maxW / sw, maxH / sh);

//if (!allow_upscale) sc = min(sc, 1);

//if (integer_scale)
//{
//    sc = floor(sc);
//    if (sc < 1) sc = 1;
//}

//// Desenha centralizado
//draw_set_alpha(a);
//draw_sprite_ext(spr, 0, gw * 0.18, gh * 0.1, sc, sc, 0, c_white, a);

//// Texto de skip (bem discreto)
//if (skip_enabled)
//{
//    if (skip_font != -1) draw_set_font(skip_font);

//    draw_set_alpha(0.65);
//    draw_set_color(c_white);
//    draw_set_halign(fa_center);
//    draw_set_valign(fa_middle);
//    draw_text(gw * 0.5, gh * 0.88, skip_text);
//}

//// Reset
//draw_set_alpha(1);
//draw_set_color(c_white);
//draw_set_halign(fa_left);
//draw_set_valign(fa_top);

/// obj_boot - Draw GUI
var guiW = display_get_gui_width();
var guiH = display_get_gui_height();
if (guiW <= 1) guiW = camera_get_view_width(view_camera[0]);
if (guiH <= 1) guiH = camera_get_view_height(view_camera[0]);

// fundo preto
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, guiW, guiH, false);

gpu_set_blendmode(bm_normal);
gpu_set_texfilter(true); // logos/fundos ficam mais bonitos

// helpers inline
function draw_fit(_spr, _cx, _cy, _maxW, _maxH, _a)
{
    var sw = sprite_get_width(_spr);
    var sh = sprite_get_height(_spr);
    var sc = min(_maxW / sw, _maxH / sh);
    draw_set_alpha(_a);
    draw_sprite_ext(_spr, 0, _cx, _cy, sc, sc, 0, c_white, _a);
}

function draw_cover(_spr, _cx, _cy, _W, _H, _a)
{
    var sw = sprite_get_width(_spr);
    var sh = sprite_get_height(_spr);
    var sc = max(_W / sw, _H / sh);
    draw_set_alpha(_a);
    draw_sprite_ext(_spr, 0, _cx, _cy, sc, sc, 0, c_white, _a);
}

// qual tela desenhar
if (state <= 2)
{
    // SPLASH STUDIO
    if (sprite_exists(spr_studio))
        draw_fit(spr_studio, guiW * 0.5, guiH * 0.5, guiW * 0.85, guiH * 0.85, alpha);
}
else
{
    // TELA DE TÍTULO
    if (spr_title_bg != -1 && sprite_exists(spr_title_bg))
        draw_cover(spr_title_bg, guiW * 0.5, guiH * 0.5, guiW, guiH, alpha);

    if (sprite_exists(spr_title))
        draw_fit(spr_title, guiW * 0.5, guiH * 0.42, guiW * 0.90, guiH * 0.70, alpha);

    // "press any key"
    if (state == 4)
    {
        var blink = 0.35 + 0.65 * abs(sin(current_time * 0.004));
        draw_set_alpha(blink);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(guiW * 0.5, guiH * 0.86, "Pressione qualquer tecla");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

gpu_set_texfilter(false);
draw_set_alpha(1);
draw_set_color(c_white);
