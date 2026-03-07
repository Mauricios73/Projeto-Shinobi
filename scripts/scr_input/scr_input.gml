enum InputAction {
    ACT_UP,
    ACT_DOWN,
    ACT_LEFT,
    ACT_RIGHT,

    ACT_MOVE_X,

    ACT_JUMP,
    ACT_ATTACK,
    ACT_DASH,
    ACT_CHIDORI,
    ACT_FIRE,
    ACT_CHAKRA,

    ACT_ENTER,
    ACT_BACK,
}

function __input_get()
{
    if (variable_global_exists("__input_id") && instance_exists(global.__input_id))
        return global.__input_id;

    var inst = instance_find(obj_input, 0);
    if (inst != noone) {
        global.__input_id = inst;
        return inst;
    }
    return noone;
}

function scr_input_init_defaults()
{
    // Defaults (se o menu já setar global.key_*, ele sobrescreve depois — ok)
    if (!variable_global_exists("key_up"))     global.key_up     = ord("W");
    if (!variable_global_exists("key_down"))   global.key_down   = ord("S");
    if (!variable_global_exists("key_left"))   global.key_left   = ord("A");
    if (!variable_global_exists("key_right"))  global.key_right  = ord("D");
    if (!variable_global_exists("key_enter"))  global.key_enter  = vk_enter;

    if (!variable_global_exists("key_fire"))   global.key_fire   = ord("F");
    if (!variable_global_exists("key_chakra")) global.key_chakra = ord("R");
    if (!variable_global_exists("key_dash"))   global.key_dash   = ord("L");
    if (!variable_global_exists("key_chidori"))global.key_chidori= ord("J");
    if (!variable_global_exists("key_ataque")) global.key_ataque = ord("K");

    actions_count = InputAction.ACT_BACK + 1;

    _bind     = array_create(actions_count);
    _down     = array_create(actions_count, false);
    _prev     = array_create(actions_count, false);
    _pressed  = array_create(actions_count, false);
    _released = array_create(actions_count, false);
    _axis     = array_create(actions_count, 0);

    // { key, pad_btn, pad_axis, is_axis }
    _bind[InputAction.ACT_UP]    = { key: global.key_up,    pad_btn: gp_padu,  pad_axis: -1,        is_axis: false };
    _bind[InputAction.ACT_DOWN]  = { key: global.key_down,  pad_btn: gp_padd,  pad_axis: -1,        is_axis: false };
    _bind[InputAction.ACT_LEFT]  = { key: global.key_left,  pad_btn: gp_padl,  pad_axis: -1,        is_axis: false };
    _bind[InputAction.ACT_RIGHT] = { key: global.key_right, pad_btn: gp_padr,  pad_axis: -1,        is_axis: false };

    _bind[InputAction.ACT_ENTER] = { key: global.key_enter, pad_btn: gp_face1, pad_axis: -1,        is_axis: false };
    _bind[InputAction.ACT_BACK]  = { key: vk_escape,        pad_btn: gp_face2, pad_axis: -1,        is_axis: false };

    _bind[InputAction.ACT_JUMP]    = { key: global.key_up,      pad_btn: gp_face1,     pad_axis: -1, is_axis: false };
    _bind[InputAction.ACT_ATTACK]  = { key: global.key_ataque,  pad_btn: gp_face2,     pad_axis: -1, is_axis: false };
    _bind[InputAction.ACT_DASH]    = { key: global.key_dash,    pad_btn: gp_face3,     pad_axis: -1, is_axis: false };
    _bind[InputAction.ACT_CHIDORI] = { key: global.key_chidori, pad_btn: gp_shoulderr, pad_axis: -1, is_axis: false };
    _bind[InputAction.ACT_FIRE]    = { key: global.key_fire,    pad_btn: gp_shoulderl, pad_axis: -1, is_axis: false };
    _bind[InputAction.ACT_CHAKRA]  = { key: global.key_chakra,  pad_btn: gp_face4,     pad_axis: -1, is_axis: false };

    _bind[InputAction.ACT_MOVE_X]  = { key: -1, pad_btn: -1, pad_axis: gp_axislh, is_axis: true };
}

function scr_input_update()
{
    // roda no contexto do obj_input (porque é chamado do Step dele)
    for (var i = 0; i < actions_count; i++) {
        _pressed[i] = false;
        _released[i] = false;
        _axis[i] = 0;
    }

    var pad_ok = gamepad_is_connected(pad_id);

    // Axis MOVE_X (controle) + fallback teclado
    var ax = 0;
    if (pad_ok) {
        ax = gamepad_axis_value(pad_id, _bind[InputAction.ACT_MOVE_X].pad_axis);
        if (abs(ax) < deadzone) ax = 0;
    }

    var kx = keyboard_check(_bind[InputAction.ACT_RIGHT].key) - keyboard_check(_bind[InputAction.ACT_LEFT].key);
    if (kx != 0) ax = kx;

    _axis[InputAction.ACT_MOVE_X] = clamp(ax, -1, 1);

    // Digitais
    for (var a = 0; a < actions_count; a++) {
        if (_bind[a].is_axis) continue;

        var down_now = false;

        var kk = _bind[a].key;
        if (kk != -1) down_now |= keyboard_check(kk);

        if (pad_ok) {
            var pb = _bind[a].pad_btn;
            if (pb != -1) down_now |= gamepad_button_check(pad_id, pb);
        }

        _down[a] = down_now;

        _pressed[a]  = (_down[a] && !_prev[a]);
        _released[a] = (!_down[a] && _prev[a]);
        _prev[a] = _down[a];
    }
}

// --- GETTERS: podem ser chamados de qualquer objeto ---
function scr_input_down(_action)
{
    var inp = __input_get();
    if (inp == noone) return false;
    return inp._down[_action];
}

function scr_input_pressed(_action)
{
    var inp = __input_get();
    if (inp == noone) return false;
    return inp._pressed[_action];
}

function scr_input_released(_action)
{
    var inp = __input_get();
    if (inp == noone) return false;
    return inp._released[_action];
}

function scr_input_axis(_action)
{
    var inp = __input_get();
    if (inp == noone) return 0;
    return inp._axis[_action];
}