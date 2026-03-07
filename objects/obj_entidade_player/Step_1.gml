// Olhando para o lado certo (considera impulso/dash também)
var _dir = velh + mid_velh;
if (_dir != 0) xscale = sign(_dir);
image_xscale = xscale;

// Exibir estados 
if (position_meeting(mouse_x, mouse_y, id))
{
    if (mouse_check_button_released(mb_left))
        mostra_estado = !mostra_estado;
}

image_speed = (img_spd / room_speed * global.vel_mult);
