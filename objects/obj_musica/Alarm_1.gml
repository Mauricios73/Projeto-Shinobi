var rn_music = room_get_name(room);
if (rn_music == "rm_init" || rn_music == "rm_menu") exit;

if (audio_is_playing(mus_atual)) {
    alarm[1] = room_speed;
} else {
    alarm[0] = room_speed * irandom_range(pause_min, pause_max);
}
