// obj_dano - Draw
if (!variable_global_exists("debug") || !global.debug) exit;
if (is_undefined(config)) exit;

draw_set_color(c_red);
draw_rectangle(x - config.size,
               y - config.size,
               x + config.size,
               y + config.size,
               true);
