// Inherit the parent event
event_inherited();

	var x1 = camera_get_view_x(view_camera[0]);
	var y1 = camera_get_view_y(view_camera[0]);

draw_text(x1 + 10, y1 + 25, dash_timer);
draw_text(x1 + 10, y1 + 10, vida_atual);
