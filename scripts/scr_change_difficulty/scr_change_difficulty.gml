///@description change_difficulty
///@arg idx
///@arg slot
function change_difficulty(_idx, _slot) 
{
    _idx = clamp(_idx, 0, 2);

    if (_slot == 0) global.difficulty_enemies = _idx;
    else            global.difficulty_allies  = _idx;

    // Ajuste dos Multiplicadores de Dano e HP
// Define os parâmetros de comportamento global baseados na dificuldade dos inimigos
    switch (global.difficulty_enemies)
    {
        case 0: // FÁCIL (HARMLESS)
            global.enemy_dmg_mult      = 1;
            global.enemy_hp_mult       = 0.75;
            global.enemy_reaction_time = 60; // 1 segundo de "atraso" antes de agir
            global.enemy_block_chance  = 5;  // Quase nunca defende
            global.enemy_dodge_chance  = 0;  // Não esquiva
            break;

        case 1: // NORMAL
            global.enemy_dmg_mult      = 2.00;
            global.enemy_hp_mult       = 1.00;
            global.enemy_reaction_time = 30; // 0.5 segundos de reação
            global.enemy_block_chance  = 30; // Defende ocasionalmente
            global.enemy_dodge_chance  = 15; // Esquiva as vezes
            break;

        case 2: // DIFÍCIL (TERRIBLE)
            global.enemy_dmg_mult      = 4;
            global.enemy_hp_mult       = 1.25;
            global.enemy_reaction_time = 10; // Reação quase instantânea
            global.enemy_block_chance  = 65; // Mestre da defesa
            global.enemy_dodge_chance  = 40; // Esquiva muito bem
            break;
    }
}
    //switch (global.difficulty_allies)
    //{
    //    case 0: global.player_dmg_mult = 0.85; break;
    //    case 1: global.player_dmg_mult = 1.00; break;
    //    case 2: global.player_dmg_mult = 1.15; break;
    //}
	
    
    // Marca o menu como sujo para salvar no INI (se o menu existir)
    var _m = instance_find(obj_menu, 0);
    if (_m != noone) {
        _m.menu_dirty = true;
        _m.menu_dirty_timer = room_speed; 
    }
