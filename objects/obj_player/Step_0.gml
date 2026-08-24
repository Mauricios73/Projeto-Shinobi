// obj_player Step_0.gml
// Refatorado: este evento agora apenas orquestra input, FSM e física.
// A lógica pesada foi movida para scripts em scripts/scr_player_*.

if (instance_exists(obj_transicao)) exit;

scr_player_input_update();

if (!scr_player_state_machine_pre_step()) {
    exit;
}

scr_player_state_machine_step();
scr_player_physics_apply_movement();
