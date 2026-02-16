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
