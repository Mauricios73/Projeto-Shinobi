///@description change_difficulty
///@arg idx (0..2)
///@arg [slot] 0=enemies, 1=allies
function change_difficulty(idx, slot)
{
    idx = clamp(idx, 0, 2);

    if (!variable_global_exists("difficulty_enemies")) global.difficulty_enemies = 1;
    if (!variable_global_exists("difficulty_allies"))  global.difficulty_allies  = 1;

    if (argument_count >= 2)
    {
        if (slot == 0) global.difficulty_enemies = idx;
        else          global.difficulty_allies  = idx;
    }
    else
    {
        // fallback: tenta descobrir pelo menu atual (sem precisar mexer no Create do menu)
        var m = instance_find(obj_menu, 0);
        if (m != noone && variable_instance_exists(m, "menu_pages") && variable_instance_exists(m, "page") && variable_instance_exists(m, "menu_option"))
        {
            var ds_ = m.menu_pages[m.page];
            var opt = m.menu_option[m.page];
            var label = ds_[# 0, opt];

            if (label == "ENEMIES") global.difficulty_enemies = idx;
            else if (label == "ALLIES") global.difficulty_allies = idx;
            else global.difficulty_enemies = idx;
        }
        else
        {
            global.difficulty_enemies = idx;
        }
    }

    // aplica multiplicadores (ajuste fino depois)
    switch (global.difficulty_enemies)
    {
        case 0: global.enemy_dmg_mult = 0.75; global.enemy_hp_mult = 0.75; break; // harmless
        case 1: global.enemy_dmg_mult = 1.00; global.enemy_hp_mult = 1.00; break; // normal
        case 2: global.enemy_dmg_mult = 1.35; global.enemy_hp_mult = 1.25; break; // terrible
    }

    switch (global.difficulty_allies)
    {
        case 0: global.player_dmg_mult = 0.85; break;
        case 1: global.player_dmg_mult = 1.00; break;
        case 2: global.player_dmg_mult = 1.15; break;
    }

    // marca menu como "dirty" se existir (salvar via debounce)
    var mm = instance_find(obj_menu, 0);
    if (mm != noone)
    {
        if (!variable_instance_exists(mm, "menu_dirty")) mm.menu_dirty = false;
        if (!variable_instance_exists(mm, "menu_dirty_timer")) mm.menu_dirty_timer = 0;
        mm.menu_dirty = true;
        mm.menu_dirty_timer = current_time;
    }
}
