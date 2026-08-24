// obj_hitbox - Destroy
// Garante limpeza da instância de dano persistente vinculada.

scr_hitbox_destroy_ref(damage_inst);

if (instance_exists(owner))
{
    if (variable_instance_exists(owner, "fire_hitbox") && owner.fire_hitbox == id) owner.fire_hitbox = noone;
    if (variable_instance_exists(owner, "chidori_hit") && owner.chidori_hit == id) owner.chidori_hit = noone;
}
