// 1. Detectar tecla de pausa
/*var key_pause = keyboard_check_pressed(vk_escape);
if (gamepad_is_connected(0)) {
    if (gamepad_button_check_pressed(0, gp_start)) key_pause = true;
}

// 2. Só permitir pausar se NÃO estiver na sala do menu principal
// (Ajuste "rm_menu" para o nome real da sua sala de menu inicial)
if (room != rm_menu) { 
    if (key_pause && !game_over) {
        global.pause = !global.pause;
        
        if (global.pause) {
            instance_deactivate_all(true);
            instance_activate_object(obj_menu);
            instance_activate_object(obj_game_controller);
            instance_activate_object(obj_musica); 
            instance_activate_object(obj_ambiente);
        } else {
            instance_activate_all();
        }
    }
}

// 3. Bloqueio de lógica se estiver pausado
if (global.pause) exit;

// 4. Lógica de Game Over
if (game_over) {
    global.vel_mult = 0.4;
    if (keyboard_check_released(vk_enter)) {
        game_over = false;
        global.vel_mult = 1;
        if (variable_global_exists("checkpoint_room")) {
            room_goto(global.checkpoint_room);
        } else {
            room_goto(Room1); 
        }
    }
} else {
    global.vel_mult = 1;
}
*/

/*if (game_over){
	
	
	if (game_over && keyboard_check_pressed(vk_enter)) {
	    global.pause = false;
		global.vel_mult = .4;
	    //game_over = false;
	    valor = 0;
    
	    // Se você tiver um checkpoint salvo
	    if (variable_global_exists("checkpoint_room")) {
	        room_goto(global.checkpoint_room);
	    } else {
	        room_goto(Room1); // Ou a sala que você desejar
	    }
	}
}
else
{
	global.vel_mult = 1;
}