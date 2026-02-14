if (!instance_exists(owner)) { instance_destroy(); exit; }

var s   = obj_skill_controller.fire_breath;
var dir = owner.image_xscale;

x = owner.x + dir * s.fx_offset_x;
y = owner.y + s.fx_offset_y;
image_xscale = dir;

// cria hitbox UMA vez
if (!instance_exists(hit))
{
    hit = instance_create_layer(x, y, layer, obj_dano);
    hit.pai = owner;
    hit.dano = s.damage_base + (s.level - 1);
	hit.skill_id = "fire_breath";
    hit.image_xscale = dir;
show_debug_message("Criou hitbox com skill_id=fire_breath");

    // configura como hitbox persistente com ticks
	hit.persistente = true;
	hit.tick_frames = 1;        // frequência
	hit.max_hits_por_alvo = 5;  // total de hits por alvo nesse jutsu

    //hit.tick_frames = ceil((sprite_get_number(spr_fire_breath) / 3) * 1); // aprox p/ 3 hits no total
    // Melhor: fixo (ex: 8 frames) dependendo do seu room_speed.
}
else
{
    hit.x = x;
    hit.y = y;
    hit.image_xscale = dir;
    hit.pai = owner;
    hit.dano = s.damage_base + (s.level - 1);
}

// acabou a animação do fogo
if (image_index >= image_number - 1)
{
    if (instance_exists(hit)) with (hit) instance_destroy();

    var sc = instance_find(obj_skill_controller, 0);
    if (sc != noone) sc.end_fire(owner);

    owner.estado = "parado";
    instance_destroy();
}
