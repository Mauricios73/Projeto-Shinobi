/// obj_menu - Step (PATCH A: robust + debounce)
if (!variable_instance_exists(self, "inputting")) inputting = false;
if (!variable_instance_exists(self, "menu_pages")) exit;
if (!variable_instance_exists(self, "menu_option")) exit;
if (!variable_instance_exists(self, "page")) exit;

var prev_inputting = inputting;

// Pause gating
if (variable_global_exists("menu_mode"))
{
    if (global.menu_mode == "pause" && !global.pause) exit;
}
else
{
    if (!global.pause) exit;
}

// Helpers
function _mark_dirty()
{
    menu_dirty = true;
    menu_dirty_timer = ceil(room_speed * 0.35); // ~350ms
}

function _exec(_fn, _a, _b, _has_b)
{
    if (is_undefined(_fn)) return;

    if (is_real(_fn))
    {
        if (_has_b) script_execute(_fn, _a, _b);
        else        script_execute(_fn, _a);
        return;
    }

    if (is_string(_fn))
    {
        var sid = asset_get_index(_fn);
        if (sid != -1)
        {
            if (_has_b) script_execute(sid, _a, _b);
            else        script_execute(sid, _a);
        }
        return;
    }

    // assume callable (function/method)
    if (_has_b) _fn(_a, _b);
    else        _fn(_a);
}

// Inputs
var input_up_p     = keyboard_check_pressed(global.key_up);
var input_down_p   = keyboard_check_pressed(global.key_down);
var input_enter_p  = keyboard_check_pressed(global.key_enter);
var input_revert_p = keyboard_check_pressed(global.key_revert);

var ds_ = menu_pages[page];
var ds_height = ds_grid_height(ds_);

// =========================
// INPUTTING (edit mode)
// =========================
if (inputting)
{
    var opt = menu_option[page];
    var etype = ds_[# 1, opt];

    switch (etype)
    {
        case menu_element_type.shift:
        {
            var h = keyboard_check_pressed(global.key_right) - keyboard_check_pressed(global.key_left);
            if (h != 0)
            {
                ds_[# 3, opt] += h;
                ds_[# 3, opt] = clamp(ds_[# 3, opt], 0, array_length(ds_[# 4, opt]) - 1);

                var val = ds_[# 3, opt];
                var fn  = ds_[# 2, opt];
                var extra = ds_[# 5, opt];

                _exec(fn, val, extra, true);
                _mark_dirty();
            }
        }
        break;

        case menu_element_type.slider:
        {
            var h = keyboard_check(global.key_right) - keyboard_check(global.key_left);
            if (h != 0)
            {
                ds_[# 3, opt] += h * 0.01;
                ds_[# 3, opt] = clamp(ds_[# 3, opt], 0, 1);

                var val = ds_[# 3, opt];
                var fn  = ds_[# 2, opt];
                var extra = ds_[# 5, opt];

                _exec(fn, val, extra, true);
                _mark_dirty();
            }
        }
        break;

        case menu_element_type.toggle:
        {
            var h = keyboard_check_pressed(global.key_right) - keyboard_check_pressed(global.key_left);
            if (h != 0)
            {
                ds_[# 3, opt] += h;
                ds_[# 3, opt] = clamp(ds_[# 3, opt], 0, 1);

                var val = ds_[# 3, opt];
                var fn  = ds_[# 2, opt];
                var extra = ds_[# 5, opt];

                _exec(fn, val, extra, true);
                _mark_dirty();
            }
        }
        break;

        case menu_element_type.input:
        {
            if (input_revert_p) { inputting = false; break; }

            var kk = keyboard_lastkey;
            if (kk != 0 && kk != vk_enter)
            {
                if (kk != ds_[# 3, opt])
                {
                    ds_[# 3, opt] = kk;
                    variable_global_set(ds_[# 2, opt], kk);
                    _mark_dirty();
                }
                inputting = false;
            }
        }
        break;
    }
}
else
{
    // navigation
    var ochange = input_down_p - input_up_p;
    if (ochange != 0)
    {
        menu_option[page] += ochange;
        if (menu_option[page] > ds_height - 1) menu_option[page] = 0;
        if (menu_option[page] < 0)             menu_option[page] = ds_height - 1;
    }
}

// =========================
// ENTER
// =========================
if (input_enter_p)
{
    var opt = menu_option[page];
    var etype = ds_[# 1, opt];

    switch (etype)
    {
        case menu_element_type.script_runner:
            _exec(ds_[# 2, opt], 0, 0, false);
        break;

        case menu_element_type.page_transfer:
            page = ds_[# 2, opt];
        break;

        default:
            inputting = !inputting;
        break;
    }
}

// =========================
// SAVE debounce
// =========================
if (prev_inputting && !inputting)
{
    if (menu_dirty) { scr_save_settings(); menu_dirty = false; menu_dirty_timer = 0; }
}
else if (menu_dirty && !inputting)
{
    menu_dirty_timer--;
    if (menu_dirty_timer <= 0)
    {
        scr_save_settings();
        menu_dirty = false;
    }
}
