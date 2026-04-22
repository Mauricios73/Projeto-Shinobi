/// obj_input - Create
persistent = true;
global.__input_id = id;

// Config
pad_id = 0;
deadzone = 0.30;

// Debug
debug_enabled = true;

// Estado (será inicializado pelo script)
actions_count = 0;
_bind = undefined;
_down = undefined;
_prev = undefined;
_pressed = undefined;
_released = undefined;
_axis = undefined;

// Inicializa
scr_input_init_defaults();
show_debug_message("input ok");

/// reload_binds() - atualiza os binds com as globais atuais
reload_binds = function() {
    _bind[InputAction.ACT_UP].key = global.key_up;
    _bind[InputAction.ACT_DOWN].key = global.key_down;
    _bind[InputAction.ACT_LEFT].key = global.key_left;
    _bind[InputAction.ACT_RIGHT].key = global.key_right;
    _bind[InputAction.ACT_ENTER].key = global.key_enter;
    _bind[InputAction.ACT_BACK].key = vk_escape; // fixo, mas pode ser global se quiser
    _bind[InputAction.ACT_JUMP].key = global.key_up;
    _bind[InputAction.ACT_ATTACK].key = global.key_ataque;
    _bind[InputAction.ACT_DASH].key = global.key_dash;
    _bind[InputAction.ACT_CHIDORI].key = global.key_chidori;
    _bind[InputAction.ACT_FIRE].key = global.key_fire;
    _bind[InputAction.ACT_CHAKRA].key = global.key_chakra;
};