///// obj_boot - Step
//// Skip (teclado / mouse)
//if (skip_enabled)
//{
//    if (keyboard_check_pressed(vk_anykey)
//    || mouse_check_button_pressed(mb_left)
//    || mouse_check_button_pressed(mb_right))
//    {
//        room_goto(target_room);
//        exit;
//    }
//}

//// Se acabou a sequência (segurança)
//if (idx >= array_length(seq))
//{
//    room_goto(target_room);
//    exit;
//}

//// Timer
//var dt = 1 / room_speed;
//t += dt;

//var s = seq[idx];
//var total = s.fade_in + s.hold + s.fade_out;

//// Alpha do fade
//if (t < s.fade_in)
//{
//    a = t / s.fade_in;
//}
//else if (t < s.fade_in + s.hold)
//{
//    a = 1;
//}
//else
//{
//    a = 1 - ((t - (s.fade_in + s.hold)) / s.fade_out);
//}

//a = clamp(a, 0, 1);

//// Próximo logo
//if (t >= total)
//{
//    idx++;
//    t = 0;

//    if (idx >= array_length(seq))
//    {
//        room_goto(target_room);
//        exit;
//    }
//}

/// obj_boot - Step
var dt = 1 / room_speed;
t += dt;
if (skip_lock > 0) skip_lock -= dt;

var pressed =
    (skip_lock <= 0) &&
    (keyboard_check_pressed(vk_anykey) ||
     mouse_check_button_pressed(mb_left) ||
     mouse_check_button_pressed(mb_right));

switch (state)
{
    case 0: // fade in studio
        alpha = clamp(t / fade_in_time, 0, 1);
        if (t >= fade_in_time) { state = 1; t = 0; }
    break;

    case 1: // hold studio
        alpha = 1;
        if (pressed) { state = 5; t = 0; } // skip direto pro menu
        else if (t >= hold_time) { state = 2; t = 0; }
    break;

    case 2: // fade out studio
        alpha = 1 - clamp(t / fade_out_time, 0, 1);
        if (t >= fade_out_time) { state = 3; t = 0; }
    break;

    case 3: // fade in title
        alpha = clamp(t / title_fade_in, 0, 1);
        if (pressed) { state = 5; t = 0; } // skip direto pro menu
        else if (t >= title_fade_in) { state = 4; t = 0; }
    break;

    case 4: // wait "press any key"
        alpha = 1;
        if (pressed) { state = 5; t = 0; }
        else if (auto_to_menu && t >= auto_wait) { state = 5; t = 0; }
    break;

    case 5: // fade out -> menu
        alpha = 1 - clamp(t / fade_out_time, 0, 1);
        if (t >= fade_out_time)
        {
            room_goto(target_room);
            instance_destroy();
        }
    break;
}
