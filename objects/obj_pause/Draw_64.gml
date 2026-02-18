/// obj_pause - DRAW GUI

if (!global.pause) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();


// ==========================================
// CAPTURA NA PRIMEIRA FRAME DO PAUSE
// ==========================================

if (!pause_captured)
{
    if (surface_exists(global.pause_surface))
        surface_free(global.pause_surface);

    var sw = surface_get_width(application_surface);
    var sh = surface_get_height(application_surface);

    global.pause_surface = surface_create(sw, sh);

    surface_set_target(global.pause_surface);
    draw_clear_alpha(c_black, 0);
    draw_surface(application_surface, 0, 0);
    surface_reset_target();

    pause_captured = true;
}


// ==========================================
// DESENHAR BLUR
// ==========================================

if (surface_exists(global.pause_surface))
{
    shader_set(shd_pause_blur);

    var u_blur = shader_get_uniform(shd_pause_blur, "blur_amount");

    // blur proporcional à resolução
    shader_set_uniform_f(u_blur, 1.0 / surface_get_width(global.pause_surface));

    draw_surface_stretched(
        global.pause_surface,
        0,
        0,
        gw,
        gh
    );

    shader_reset();
}


// overlay escuro elegante
draw_set_alpha(0.4);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);
draw_set_alpha(1);


// ==========================================
// PAINEL BORDA
// ==========================================

var panel_w = gw * 0.55;
var panel_h = gh * 0.65;

var px = gw/2 - panel_w/2;
var py = gh/2 - panel_h/2;

draw_sprite_stretched(
    panel_transparent_border_015,
    0,
    px,
    py,
    panel_w,
    panel_h
);


// ==========================================
// TÍTULO
// ==========================================

draw_set_font(fnt_asian_ninja);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_black);
draw_text(gw/2 + 2, py + 42, "PAUSE");

draw_set_color(make_color_rgb(170,20,20));
draw_text(gw/2, py + 40, "PAUSE");

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
