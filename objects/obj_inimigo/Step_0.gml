// obj_inimigo - Step

if (!place_meeting(x, y + 1, obj_block))
{
    velv += GRAVIDADE * massa;
}

var clone_proximo = instance_nearest(x, y, obj_ally);
var player_proximo = instance_nearest(x, y, obj_player);

alvo = noone;

if (clone_proximo != noone && distance_to_object(clone_proximo) < dist_visao)
{
    alvo = clone_proximo;
}
else if (player_proximo != noone && distance_to_object(player_proximo) < dist_visao)
{
    alvo = player_proximo;
}

var dir_alvo = image_xscale;
if (alvo != noone && instance_exists(alvo))
{
    dist = point_distance(x, y, alvo.x, alvo.y);
    dir_alvo = sign(alvo.x - x);
}
else
{
    dist = 99999;
}

switch (estado)
{
    case "idle":
        velh = 0;
        sprite_index = spr_inimigo_idle;

        if (alvo != noone)
        {
            timer_reacao++;
            var reaction_time = variable_global_exists("enemy_reaction_time") ? global.enemy_reaction_time : 30;
            if (timer_reacao >= reaction_time)
            {
                enemy_set_state("perseguicao");
                timer_reacao = 0;
            }
        }
        else if (irandom(120) == 0)
        {
            enemy_set_state("patrulha");
        }
    break;

    case "patrulha":
        sprite_index = spr_inimigo_run;
        image_xscale = patrol_dir;
        velh = patrol_dir * (max_velh * 0.5);

        if (abs(x - patrol_origin_x) > dist_patrulha || place_meeting(x + velh, y, obj_block))
        {
            patrol_dir *= -1;
        }

        if (alvo != noone)
        {
            enemy_set_state("perseguicao");
        }
        else if (irandom(180) == 0)
        {
            enemy_set_state("idle");
        }
    break;

    case "perseguicao":
        sprite_index = spr_inimigo_run;

        if (alvo != noone && instance_exists(alvo))
        {
            image_xscale = dir_alvo;

            var target_attacking = variable_instance_exists(alvo, "estado") && (alvo.estado == "ataque" || alvo.estado == "ataque aereo");
            var difficulty = variable_global_exists("difficulty_enemies") ? global.difficulty_enemies : 1;

            if (difficulty == 2 && target_attacking && dist < 60)
            {
                velh = 0;
            }
            else
            {
                velh = dir_alvo * max_velh;
            }

            if (dist < dist_ataque)
            {
                enemy_set_state("ataque");
                velh = 0;

                if (difficulty == 2 && irandom(99) < 30)
                {
                    tipo_ataque = "skill";
                }
                else
                {
                    tipo_ataque = choose("soco", "chute", "soco2");
                }
            }
        }
        else
        {
            enemy_set_state("patrulha");
        }
    break;

    case "ataque":
        velh = 0;

        if (tipo_ataque == "soco")
        {
            atacando(spr_inimigo_punch1, 2, 4, 25, -50);
        }
        else if (tipo_ataque == "chute")
        {
            atacando(spr_inimigo_kick, 3, 5, 30, -30);
        }
        else if (tipo_ataque == "soco2")
        {
            atacando(spr_inimigo_punch2, 2, 4, 25, -50);
        }
        else
        {
            atacando(spr_explosive_strike, 2, 4, 25, -50);
        }
    break;

    case "defesa":
        velh = 0;
        sprite_index = spr_inimigo_defend;
        if (image_index > image_number - 1) enemy_set_state("idle");
    break;

    case "esquiva":
        sprite_index = spr_inimigo_roll;
        if (image_index > image_number - 1) enemy_set_state("idle");
    break;

    case "dano":
        velh = 0;
        sprite_index = spr_inimigo_hit;
        if (image_index > image_number - 1)
        {
            enemy_set_state(alvo != noone ? "perseguicao" : "idle");
        }
    break;

    case "morte":
        velh = 0;
        sprite_index = spr_inimigo_dead;
        if (image_index > image_number - 1)
        {
            image_speed = 0;
            image_alpha -= 0.02;
            if (image_alpha <= 0) instance_destroy();
        }
    break;
}

if (estado != "ataque")
{
    image_blend = c_white;
}
