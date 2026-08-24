/// @function scr_hitbox_create_damage(_owner, _x, _y, _damage, _skill_id, _range, _shape, _persistent, _tick_frames, _max_hits, _life)
/// @description Cria e configura obj_dano de forma padronizada para ataques, skills e AOE.
function scr_hitbox_create_damage(_owner, _x, _y, _damage, _skill_id, _range, _shape, _persistent, _tick_frames, _max_hits, _life)
{
    if (!instance_exists(_owner)) return noone;

    var hb = instance_create_layer(_x, _y, _owner.layer, obj_dano);
    hb.pai = _owner;
    hb.dano = _damage;
    hb.skill_id = _skill_id;
    hb.range = _range;
    hb.shape = _shape;
    hb.persistente = _persistent;
    hb.tick_frames = _tick_frames;
    hb.max_hits_por_alvo = _max_hits;
    hb.life = _life;
    hb.morrer = false;
    return hb;
}

/// @function scr_hitbox_destroy_ref(_inst)
/// @description Destroi hitbox com checagem de instância.
function scr_hitbox_destroy_ref(_inst)
{
    if (instance_exists(_inst))
    {
        with (_inst) instance_destroy();
    }
}
