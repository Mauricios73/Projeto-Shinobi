if (!dbg_show) exit;

var p = instance_find(obj_player, 0);
if (p == noone) exit;

// linha do "pé" do player (onde testa y+1)
draw_set_color(c_lime);
draw_line(p.x - 12, p.y + 1, p.x + 12, p.y + 1);

// ponto do teste
draw_circle(p.x, p.y + 1, 2, false);

// texto no mundo
draw_set_color(c_white);
if (variable_instance_exists(p, "on_ground"))
    draw_text(p.x + 16, p.y - 40, "on_ground=" + string(p.on_ground));
if (variable_instance_exists(p, "velv"))
    draw_text(p.x + 16, p.y - 24, "velv=" + string(p.velv));
