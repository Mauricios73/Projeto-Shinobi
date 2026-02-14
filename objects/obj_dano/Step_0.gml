if (!instance_exists(pai)) { instance_destroy(); exit; }

// lista de colisões
var lista = ds_list_create();
var qtd = instance_place_list(x, y, obj_entidade, lista, 0);

var pai_parent = object_get_parent(pai.object_index);
var f = current_time; // ms

for (var i = 0; i < qtd; i++)
{
    var alvo = lista[| i];
    if (!instance_exists(alvo)) continue;	

    // não acertar aliados (mesma “família”)
    if (object_get_parent(alvo.object_index) == pai_parent) continue;

    // invencível
    if (variable_instance_exists(alvo, "invencivel") && alvo.invencivel) continue;

    // tick por alvo
    var k = string(alvo.id);

    var next_ok = 0;
    if (ds_map_exists(tick_map, k)) next_ok = tick_map[? k];
    if (f < next_ok) continue;

    // limite de hits por alvo
    if (max_hits_por_alvo != -1)
    {
        var h = 0;
        if (ds_map_exists(hits_map, k)) h = hits_map[? k];
        if (h >= max_hits_por_alvo) continue;
        hits_map[? k] = h + 1;
    }

    // aplica dano
    if (variable_instance_exists(alvo, "vida_atual"))
    {
        alvo.vida_atual -= dano;
		
		var morreu = (alvo.vida_atual <= 0);

		if (skill_id != "" && alvo.object_index == obj_dummy)
			{
				show_debug_message("HIT de skill: " + skill_id);
				var key = skill_id + "_" + string(alvo.id);
				if (!ds_map_exists(xp_lock, key))
				{
				    ds_map_add(xp_lock, key, 1);

				    var sc = instance_find(obj_skill_controller, 0);
				    if (sc != noone) sc.grant_xp_on_hit(skill_id, alvo, morreu);
				}
			}
			else if (skill_id != "")
			{
				var sc2 = instance_find(obj_skill_controller, 0);
				if (sc2 != noone) sc2.grant_xp_on_hit(skill_id, alvo, morreu);
			}


        // reação (se existir)
        if (variable_instance_exists(alvo, "estado"))
        {
            alvo.estado = "hit";
            alvo.image_index = 0;
        }

        // número de dano (vai aparecer 3x por alvo, o que condiz com “queimando”)
		var base_x = alvo.x;
		var base_y = alvo.y - (alvo.sprite_height/2);
		var num = instance_create_layer(base_x, base_y, layer, obj_dano_num);
		num.texto = string(dano);
		num.cor = (alvo.object_index == obj_dummy) ? c_white : c_orange;

    }

    // agenda próximo tick (ms)
    var ms = (tick_frames * 1000) / room_speed;
    tick_map[? k] = f + ms;

    // morte do inimigo (se for inimigo)
    if (object_get_parent(alvo.object_index) == obj_entidade_inimigo)
    {
        if (alvo.vida_atual <= 0) alvo.estado = "dead";
    }
}

ds_list_destroy(lista);

// hitbox persistente só morre quando mandarem
if (morrer) { instance_destroy(); exit; }

// ataque normal: aplica uma vez e some
if (!persistente) instance_destroy();