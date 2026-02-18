// Se o dono não existe → destruir
if (!instance_exists(owner))
{
    instance_destroy();
    exit;
}

// Se o player NÃO está mais no estado fire_breath → destruir tudo
if (owner.estado != "fire_breath")
{
    if (instance_exists(owner.fire_hitbox))
    {
        with (owner.fire_hitbox) instance_destroy();
        owner.fire_hitbox = noone;
    }

    instance_destroy();
    exit;
}

// Posicionamento
var s   = obj_skill_controller.fire_breath;
var dir = owner.image_xscale;
var lvl = s.level;

if (lvl >= 5)      sprite_index = spr_fire_breath_1;
else if (lvl >= 3) sprite_index = spr_fire_breath_1;
else               sprite_index = spr_fire_breath;

// escala cresce um pouco por level
var scale = 1 + 0.50 * (lvl - 1);   // 10% por level (ajuste)
scale = clamp(scale, 1, 2.0);       // limite pra não ficar absurdo

var scale_x = 1 + 0.15 * (lvl - 1);
var scale_y = 1 + 0.08 * (lvl - 1);
scale_x = clamp(scale_x, 1, 2.5);
scale_y = clamp(scale_y, 1, 1.8);

image_xscale = dir * scale_x;
image_yscale = scale_y;
image_xscale = dir * scale;
image_yscale = scale;


x = owner.x + dir * s.fx_offset_x;
y = owner.y + s.fx_offset_y;
image_xscale = dir;


// Criar hitbox UMA VEZ
if (!instance_exists(owner.fire_hitbox))
{
    var hb = instance_create_layer(x, y, layer, obj_hitbox);
    hb.setup_fire(owner);
    owner.fire_hitbox = hb;
}


// Se animação terminou
if (image_index >= image_number - 1)
{
    if (instance_exists(owner.fire_hitbox))
    {
        with (owner.fire_hitbox) instance_destroy();
        owner.fire_hitbox = noone;
    }

    var sc = instance_find(obj_skill_controller, 0);
    if (sc != noone) sc.end_fire(owner);

    owner.estado = "parado";

    instance_destroy();
}
