/// ============================================================
/// SCR_PLAYER_INPUT_UPDATE
/// INPUT
/// ============================================================

function scr_player_input_update()
{
    if (!variable_global_exists("key_defesa")) global.key_defesa = ord("U");
    if (!variable_global_exists("potions")) global.potions = 0;
    if (!variable_instance_exists(self, "potion_healed")) potion_healed = false;
    if (!variable_instance_exists(self, "summon_spawned")) summon_spawned = false;

    chao = place_meeting(x, y + 1, obj_block);
    parede_dir = place_meeting(x + 1, y, obj_block);
    parede_esq = place_meeting(x - 1, y, obj_block);

    right_pressed = keyboard_check_pressed(global.key_right);
    left_pressed = keyboard_check_pressed(global.key_left);
    right_held = keyboard_check(global.key_right);
    left_held = keyboard_check(global.key_left);
    run = keyboard_check(vk_shift);

    jump = keyboard_check_pressed(global.key_up);
    up = keyboard_check(global.key_up);
    down = keyboard_check(global.key_down);

    roll = keyboard_check_pressed(vk_control);
    defend = keyboard_check(global.key_defesa);

    attack = keyboard_check_pressed(global.key_ataque);
    dash = keyboard_check_pressed(global.key_dash);
    chidori = keyboard_check_pressed(global.key_chidori);
    fire = keyboard_check_pressed(global.key_fire);
    chakra = keyboard_check(global.key_chakra);

    if (gamepad_is_connected(0))
    {
        var axis_h = gamepad_axis_value(0, gp_axislh);

        if (axis_h > 0.3) right_held = true;
        if (axis_h < -0.3) left_held = true;

        if (gamepad_button_check_pressed(0, gp_face1)) jump = true;
        if (gamepad_button_check_pressed(0, gp_face2)) attack = true;
        if (gamepad_button_check_pressed(0, gp_face3)) dash = true;
        if (gamepad_button_check(0, gp_face4)) chakra = true;
        if (gamepad_button_check_pressed(0, gp_shoulderr)) chidori = true;
        if (gamepad_button_check_pressed(0, gp_shoulderl)) fire = true;
    }

    if (right_pressed)
    {
        if (dash_timer_lateral > 0 && ultima_tecla_pressionada == 1)
            is_running = true;
        else
        {
            dash_timer_lateral = tempo_double_tap;
            ultima_tecla_pressionada = 1;
        }
    }

    if (left_pressed)
    {
        if (dash_timer_lateral > 0 && ultima_tecla_pressionada == 2)
            is_running = true;
        else
        {
            dash_timer_lateral = tempo_double_tap;
            ultima_tecla_pressionada = 2;
        }
    }

    if (!right_held && !left_held) is_running = false;

    if (dash_timer_lateral > 0) dash_timer_lateral--;
    if (dash_timer > 0) dash_timer--;

    if (wall_jump_lock > 0) wall_jump_lock--;
}