if (!variable_global_exists("snow_amount")) exit;
if (global.snow_amount <= 0) exit;

var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

var total_h = global.snow_amount * 50;

// base
draw_set_alpha(0.25 + global.snow_amount * 0.4);
draw_set_color(c_white);
draw_rectangle(0, guiH - total_h, guiW, guiH, false);

// camada irregular superior
draw_set_alpha(0.6);

for (var xx = 0; xx < guiW; xx += 4)
{
    var offset = sin(xx * 0.05 + current_time * 0.001) * 3;
    var layer_h = guiH - total_h + offset;

    draw_rectangle(xx, layer_h, xx + 4, layer_h + 2, false);
}

draw_set_alpha(1);
