// Inherit the parent event
event_inherited();

draw_text(x, y - sprite_height * 1, vida_atual);
//linha de visão
draw_line(x, y - sprite_height/2, x + (dist * xscale), y - sprite_height/2);