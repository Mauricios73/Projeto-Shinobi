/// @function scr_player_skills_handle_global_actions()
/// @description Processa ações globais permitidas apenas em estados livres.
function scr_player_skills_handle_global_actions()
{
    var _state_free_ground = (pstate == PST_IDLE || pstate == PST_RUN);
    var _state_free_air    = (pstate == PST_JUMP);
    var _state_can_skill   = (_state_free_ground || _state_free_air);

    // Summon: chão, estado livre e sem aliado ativo.
    var _input_summon = scr_input_pressed(InputAction.ACT_SUMMON);
    if (_input_summon && _state_free_ground && chao && !instance_exists(obj_ally)) {
        summon_spawned = false;
        player_set_state(PST_SUMMON);
    }

    // Potion: consome uma vez e nunca ultrapassa vida_max.
    var _input_potion = scr_input_pressed(InputAction.ACT_POTION);
    if (_input_potion && _state_free_ground && global.potions > 0 && vida_atual < vida_max)
    {
        global.potions -= 1;
        potion_healed = false;
        player_set_state(PST_POTION);
    }

    // Teleporte por I: só em estado livre de chão e sem parede no destino.
    if (keyboard_check_pressed(ord("I")) && _state_free_ground) {
        var _dir = image_xscale;
        target_x = x + (teleport_dist * _dir);
        target_y = y;

        if (!place_meeting(target_x, target_y, obj_block)) {
            player_set_state(PST_TELEPORT_OUT);
            velh = 0;
            velv = 0;
        } else {
            show_debug_message("Teleporte bloqueado por parede!");
        }
    }

    // Skills via controller.
    var sc = instance_find(obj_skill_controller, 0);
    if (_state_can_skill && sc != noone)
    {
        if (fire)
        {
            if (sc.start_fire(self)) player_sync_state_from_string();
        }
        else if (chidori)
        {
            if (sc.start_chidori(self)) player_sync_state_from_string();
        }
    }

    // Chakra hold gate.
    if (chakra)
    {
        if (_state_free_ground) player_set_state(PST_CHAKRA);
    }
    else
    {
        if (pstate == PST_CHAKRA) player_set_state(PST_IDLE);
    }
}
