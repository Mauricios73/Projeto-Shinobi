// obj_dano - Draw
if (!variable_global_exists("debug") || !global.debug) exit;

var old_alpha = draw_get_alpha();
draw_set_alpha(0.45);
draw_set_color(c_red);

if (variable_instance_exists(id, "range") && range > 0)
{
    var shape_local = variable_instance_exists(id, "shape") ? shape : 0;
    if (shape_local == 1)
    {
        draw_circle(x, y, range, true);
    }
    else
    {
        draw_rectangle(x - range, y - range, x + range, y + range, true);
    }
}
else
{
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
}

draw_set_alpha(old_alpha);
draw_set_color(c_white);
