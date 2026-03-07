// obj_game_controller - Step
// Controle de game over + reinício

if (!variable_global_exists("game_over")) global.game_over = false;

// espelha variável de instância
global.game_over = game_over;

if (game_over)
{
    global.vel_mult = 0.15;

    // ENTER reinicia a room atual
    if (keyboard_check_pressed(vk_enter))
    {
        game_over = false;
        global.game_over = false;
        global.vel_mult = 1;
        room_restart();
        exit;
    }

    // ESC volta para menu se existir
    if (keyboard_check_pressed(vk_escape))
    {
        game_over = false;
        global.game_over = false;
        global.vel_mult = 1;
        if (room_exists(rm_menu)) room_goto(rm_menu);
        else room_restart();
        exit;
    }

    exit;
}
else
{
    global.vel_mult = 1;
}
