if (!surface_exists(surf_fog)) exit;

surface_set_target(surf_fog);
draw_clear_alpha(c_black, 0);

var t = current_time * fog_speed;

for (var l = 0; l < fog_layers; l++)
{
    var layer_alpha = 0.05 + l * 0.03;
    var offset = t * (10 + l * 15);

    draw_set_alpha(layer_alpha);

    for (var i = 0; i < 20; i++)
    {
        var xx = frac(i * 0.17 + offset) * surface_get_width(surf_fog);
        var yy = (i * 37 mod surface_get_height(surf_fog));

        draw_circle(xx, yy, 30 + l * 20, false);
    }
}

surface_reset_target();

gpu_set_texfilter(true);
draw_surface_stretched(surf_fog, 0, 0, guiW, guiH);
gpu_set_texfilter(false);

draw_set_alpha(1);
