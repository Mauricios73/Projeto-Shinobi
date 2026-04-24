// obj_dano - Destruir

if (instance_exists(damage_inst))
{
    with (damage_inst) instance_destroy();
}

if (instance_exists(owner))
{
    if (variable_instance_exists(owner, "fire_hitbox") && owner.fire_hitbox == id) owner.fire_hitbox = noone;
    if (variable_instance_exists(owner, "chidori_hit") && owner.chidori_hit == id) owner.chidori_hit = noone;
}
