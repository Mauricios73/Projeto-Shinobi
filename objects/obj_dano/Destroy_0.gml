if (ds_exists(tick_map, ds_type_map)) ds_map_destroy(tick_map);
if (ds_exists(hits_map, ds_type_map)) ds_map_destroy(hits_map);
if (ds_exists(xp_lock, ds_type_map)) ds_map_destroy(xp_lock);

// (se você ainda usa pai.dano em ataques antigos, proteja)
if (instance_exists(pai) && variable_instance_exists(pai, "dano"))
{
    pai.dano = noone;
}

if (variable_global_exists("debug") && global.debug)
    show_debug_message("OBJ_DANO DESTROY id=" + string(id) + " skill=" + string(skill_id));
