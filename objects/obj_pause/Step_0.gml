// trava
if (!variable_global_exists("pause_lock_frames")) global.pause_lock_frames = 0;
if (global.pause_lock_frames > 0) {
    global.pause_lock_frames--;
    exit;
}

// NÃO pausar no menu inicial / init
if (room == rm_menu || room == rm_init) exit;

if (keyboard_check_pressed(global.key_pause)) {

    if (!global.pause) scr_pause_open();
    else               scr_pause_close();
}
