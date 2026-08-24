// obj_game_controller - Step
// Controle de game over + reinício

if (!variable_global_exists("game_over")) global.game_over = false;

// espelha variável de instância
global.game_over = game_over;

if (game_over)
{
    if (!variable_instance_exists(id, "game_over_alpha")) game_over_alpha = 0;
    game_over_alpha = min(game_over_alpha + 0.04, 1);
    global.vel_mult = 0.15;
    global.pause = false;
    global.menu_mode = "game_over";

    if (keyboard_check_pressed(vk_enter))
    {
        restart_current_room();
        exit;
    }

    exit;
}
else
{
    game_over_alpha = 0;
    global.vel_mult = 1;
}
