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
show_debug_message("input ok")