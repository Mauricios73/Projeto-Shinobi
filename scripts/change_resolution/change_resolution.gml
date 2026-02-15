function change_resolution(idx){
    global.resolution_index = idx;

    switch(idx){
        case 0: window_set_size(640, 360); break;
        case 1: window_set_size(854, 480); break;
        case 2: window_set_size(1280, 720); break;
        case 3: window_set_size(1440, 900); break;
        case 4: window_set_size(1920, 1080); break;
    }
}


