function change_window_mode(mode){
    global.window_mode = mode;

    switch(mode){
        case 0: window_set_fullscreen(true);  break;
        case 1: window_set_fullscreen(false); break;
    }
}
