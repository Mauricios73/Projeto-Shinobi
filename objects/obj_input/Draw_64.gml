/// obj_input - Draw GUI (debug)
if (!debug_enabled) exit;

draw_set_color(c_white);
draw_text(24, 24, "INPUT DEBUG");

draw_text(24, 48, "MOVE_X: " + string(scr_input_axis(InputAction.ACT_MOVE_X)));
draw_text(24, 64, "JUMP pressed: " + string(scr_input_pressed(InputAction.ACT_JUMP)));
draw_text(24, 80, "ATTACK pressed: " + string(scr_input_pressed(InputAction.ACT_ATTACK)));
draw_text(24, 96, "DASH pressed: " + string(scr_input_pressed(InputAction.ACT_DASH)));