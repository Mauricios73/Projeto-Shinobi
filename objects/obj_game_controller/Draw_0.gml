// obj_game_controller - Draw
// Overlay de GAME OVER (sem depender de Draw GUI)

if (!game_over) exit;

var cam = view_camera[0];
var cx = camera_get_view_x(cam) + camera_get_view_width(cam) * 0.5;
var cy = camera_get_view_y(cam) + camera_get_view_height(cam) * 0.5;

draw_set_alpha(0.65);
draw_set_color(c_black);
draw_rectangle(camera_get_view_x(cam), camera_get_view_y(cam),
               camera_get_view_x(cam) + camera_get_view_width(cam),
               camera_get_view_y(cam) + camera_get_view_height(cam), false);

draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(-1);
draw_text(cx, cy - 30, "GAME OVER");
draw_text(cx, cy + 20, "ENTER: RESTART   ESC: MENU");
