// obj_game_controller - Draw GUI
if (!game_over) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var fade = variable_instance_exists(id, "game_over_alpha") ? game_over_alpha : 1;

draw_set_alpha(0.78 * fade);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

var panel_w = min(620, gw * 0.72);
var panel_h = min(300, gh * 0.48);
var px = gw * 0.5 - panel_w * 0.5;
var py = gh * 0.5 - panel_h * 0.5;

draw_set_alpha(0.82 * fade);
draw_set_color(make_color_rgb(10, 8, 8));
draw_rectangle(px, py, px + panel_w, py + panel_h, false);

draw_set_alpha(fade);
draw_set_color(make_color_rgb(150, 20, 20));
draw_rectangle(px, py, px + panel_w, py + 4, false);
draw_rectangle(px, py + panel_h - 4, px + panel_w, py + panel_h, false);
draw_rectangle(px, py, px + 4, py + panel_h, false);
draw_rectangle(px + panel_w - 4, py, px + panel_w, py + panel_h, false);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var font_title = asset_get_index("fnt_asian_ninja");
var font_body = asset_get_index("fnt_asian");

draw_set_font(font_title != -1 ? font_title : -1);
draw_set_color(c_black);
draw_text(gw * 0.5 + 2, py + 82, "GAME OVER");
draw_set_color(make_color_rgb(185, 22, 22));
draw_text(gw * 0.5, py + 80, "GAME OVER");

draw_set_font(font_body != -1 ? font_body : -1);
draw_set_color(c_white);
draw_text(gw * 0.5, py + 160, "Pressione ENTER para continuar");

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
