// obj_dano - Clear

if (ds_exists(tick_map, ds_type_map)) ds_map_destroy(tick_map);
if (ds_exists(hits_map, ds_type_map)) ds_map_destroy(hits_map);
// xp_lock removido