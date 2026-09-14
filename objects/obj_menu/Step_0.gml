/// obj_menu - Step
/// Menu principal + settings + navegacao animada.

if (variable_global_exists("game_over") && global.game_over)
{
    instance_destroy();
    exit;
}

if (!variable_instance_exists(self, "inputting")) inputting = false;
if (!variable_instance_exists(self, "menu_pages")) exit;
if (!variable_instance_exists(self, "menu_option")) exit;
if (!variable_instance_exists(self, "page")) exit;

var prev_inputting = inputting;
var is_pause_menu = variable_global_exists("menu_mode") && global.menu_mode == "pause";

// Pause gating
if (variable_global_exists("menu_mode"))
{
    if (global.menu_mode == "pause" && !global.pause) exit;
}
else
{
    if (!global.pause) exit;
}

// ------------------------------------------------------------
// ANIMACAO
// ------------------------------------------------------------
menu_time += 1;

if (menu_intro_alpha < 1)
    menu_intro_alpha = min(menu_intro_alpha + 0.035, 1);

menu_selection_bump = max(menu_selection_bump - 0.12, 0);

if (menu_last_page != page)
{
    menu_last_page = page;
    menu_selection_bump = 1;
}

// ------------------------------------------------------------
// HELPERS
// ------------------------------------------------------------
function _mark_dirty()
{
    menu_dirty = true;
    menu_dirty_timer = ceil(room_speed * 0.35);
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

    if (_has_b) _fn(_a, _b);
    else        _fn(_a);
}

function _ui_sound(_kind)
{
    if (!instance_exists(obj_menu_audio))
        return;

    var _a = instance_find(obj_menu_audio, 0);

    if (!instance_exists(_a))
        return;

    _a.menu_ui_play(_kind);
}

// ------------------------------------------------------------
// INPUTS
// ------------------------------------------------------------
var input_up_p     = keyboard_check_pressed(global.key_up);
var input_down_p   = keyboard_check_pressed(global.key_down);
var input_left_p   = keyboard_check_pressed(global.key_left);
var input_right_p  = keyboard_check_pressed(global.key_right);
var input_enter_p  = keyboard_check_pressed(global.key_enter);
var input_revert_p = keyboard_check_pressed(global.key_revert);

var ds_ = menu_pages[page];
var ds_height = ds_grid_height(ds_);

// ------------------------------------------------------------
// BACK
// ------------------------------------------------------------
if (!is_pause_menu && !inputting && input_revert_p && page != menu_page.main)
{
    page = menu_page.main;
    menu_option[page] = 0;
    menu_selection_bump = 1;
    _ui_sound("back");
    exit;
}

// ------------------------------------------------------------
// INPUTTING
// ------------------------------------------------------------
if (inputting)
{
    var opt = menu_option[page];
    var etype = ds_[# 1, opt];

    switch (etype)
    {
        case menu_element_type.shift:
        {
            var h = input_right_p - input_left_p;

            if (h != 0)
            {
                ds_[# 3, opt] += h;
                ds_[# 3, opt] = clamp(ds_[# 3, opt], 0, array_length(ds_[# 4, opt]) - 1);

                var val = ds_[# 3, opt];
                var fn  = ds_[# 2, opt];
                var extra = ds_[# 5, opt];

                _exec(fn, val, extra, true);
                _mark_dirty();
                _ui_sound("move");
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
            var h = input_right_p - input_left_p;

            if (h != 0)
            {
                ds_[# 3, opt] += h;
                ds_[# 3, opt] = clamp(ds_[# 3, opt], 0, 1);

                var val = ds_[# 3, opt];
                var fn  = ds_[# 2, opt];
                var extra = ds_[# 5, opt];

                _exec(fn, val, extra, true);
                _mark_dirty();
                _ui_sound("move");
            }
        }
        break;

        case menu_element_type.input:
        {
            if (input_revert_p)
            {
                inputting = false;
                _ui_sound("back");
                break;
            }

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
                _ui_sound("confirm");
            }
        }
        break;
    }
}
else
{
    // --------------------------------------------------------
    // NAVIGATION
    // --------------------------------------------------------
    var ochange = input_down_p - input_up_p;

    if (ochange != 0)
    {
        menu_option[page] += ochange;

        if (menu_option[page] > ds_height - 1)
            menu_option[page] = 0;

        if (menu_option[page] < 0)
            menu_option[page] = ds_height - 1;

        menu_selection_bump = 1;
        _ui_sound("move");
    }
}

// ------------------------------------------------------------
// ENTER
// ------------------------------------------------------------
if (input_enter_p)
{
    var opt = menu_option[page];
    var etype = ds_[# 1, opt];

    _ui_sound("confirm");

    switch (etype)
    {
        case menu_element_type.script_runner:
            _exec(ds_[# 2, opt], 0, 0, false);
        break;

        case menu_element_type.page_transfer:
            page = ds_[# 2, opt];
            menu_option[page] = 0;
            menu_selection_bump = 1;
        break;

        default:
            inputting = !inputting;
        break;
    }
}

// ------------------------------------------------------------
// SAVE DEBOUNCE
// ------------------------------------------------------------
if (prev_inputting && !inputting)
{
    if (menu_dirty)
    {
        scr_save_settings();
        menu_dirty = false;
        menu_dirty_timer = 0;
    }
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
