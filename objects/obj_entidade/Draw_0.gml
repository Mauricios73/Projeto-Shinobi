draw_self();

//if (mostra_estado){
//    draw_set_valign(fa_middle);
//    draw_set_halign(fa_center);
//    draw_text(x, y - sprite_height * .5, estado);
//    draw_set_valign(fa_top);
//    draw_set_halign(fa_left);
//}

//draw_set_font(-1);
//draw_set_halign(fa_left);
//draw_set_color(c_yellow);

//var x1 = camera_get_view_x(view_camera[0]);
//var y1 = camera_get_view_y(view_camera[0]);

//var sc = instance_find(obj_skill_controller, 0);

//// Debug do Player
//if (instance_exists(obj_player)) {
//    draw_text(x1 + 10, y1 + 20,  "Player HP: " + string(obj_player.vida_atual));
//    draw_text(x1 + 10, y1 + 40,  "Dano Base: " + string(obj_player.ataque));
//    draw_text(x1 + 10, y1 + 60,  "Chakra: " + string(floor(obj_player.energia)) + " / " + string(obj_player.energia_max));
//    draw_text(x1 + 10, y1 + 80,  "Chakra Regen: " + string(obj_player.energia_regen));

//    if (sc != noone)
//    {
//        // DASH
//        draw_text(x1 + 10, y1 + 110, "DASH Lv: " + string(sc.chidori.level));
//        draw_text(x1 + 10, y1 + 130, "DASH XP: " + string(sc.chidori.xp) + " / " + string(sc.chidori.xp_next));

//        // FIRE
//        draw_text(x1 + 10, y1 + 160, "FIRE Lv: " + string(sc.fire_breath.level));
//        draw_text(x1 + 10, y1 + 180, "FIRE XP: " + string(sc.fire_breath.xp) + " / " + string(sc.fire_breath.xp_next));

//        // Cooldown do Fire (se quiser)
//        draw_text(x1 + 10, y1 + 210, "FIRE CD: " + string(sc.fire_breath.cooldown_left));
//    }
//    else
//    {
//        draw_text(x1 + 10, y1 + 110, "Skill Controller: NAO ENCONTRADO");
//    }
//}

//// Vida do Dummy
//with (obj_dummy) {
//    draw_set_color(c_white);
//    draw_text(x, y - sprite_height * .12, "HP: " + string(vida_atual));
//}

//// Monitor de Instâncias
//draw_set_color(c_white);
//draw_text(x1 + 10, y1 + 240, "Instancias obj_dano: " + string(instance_number(obj_dano)));
//draw_text(x1 + 10, y1 + 260, "Instancias fire_fx: " + string(instance_number(obj_skill_fire_breath)));
