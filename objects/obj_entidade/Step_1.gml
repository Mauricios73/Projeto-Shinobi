// obj_entidade - Begin Step
// FIX: direção deve considerar impulso (mid_velh), não só velh.
var _dir = velh + mid_velh;
if (_dir != 0) xscale = sign(_dir);
image_xscale = xscale;

// Aplica fricção ao impulso de impacto (mid_velh)
// Isso faz o player parar gradualmente após o empurrão
mid_velh = lerp(mid_velh, 0, 0.1); 

// Se o valor ficar muito pequeno, zera logo para não clipar
if (abs(mid_velh) < 0.1) mid_velh = 0;

image_speed = (img_spd / room_speed * global.vel_mult);

