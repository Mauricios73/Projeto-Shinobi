// obj_dano - Step
// Engine única de dano (ataques normais + skills)
// Regras:
// - respeita invencível
// - tick por alvo em ms (current_time)
// - NÃO interrompe inimigo em 'ataque' com hits fracos (combo 1/2)
//   mas permite interrupção por skill ou dano >= 3.

if (life != 999999)
{
    life--;
    if (life <= 0) instance_destroy();
}

if (!instance_exists(pai)) { instance_destroy(); exit; }

// lista de colisões
var lista = ds_list_create();
var qtd;

// Suporta AOE (range>0) e ponto (range==0)
if (variable_instance_exists(self, "range") && range > 0)
{
    var shape_local = 0;
    if (variable_instance_exists(self, "shape")) shape_local = shape;

    if (shape_local == 1)
    {
        qtd = collision_circle_list(x, y, range, obj_entidade, false, false, lista, false);
    }
    else
    {
        qtd = collision_rectangle_list(x - range, y - range, x + range, y + range, obj_entidade, false, false, lista, false);
    }
}
else
{
    qtd = instance_place_list(x, y, obj_entidade, lista, 0);
}

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
			show_debug_message("Colidi com: " + object_get_name(alvo.object_index));
		    if (variable_instance_exists(alvo, "recebe_dano")) 
		    {
		        // Se o Ninja tem a função, chamamos ela. 
				show_debug_message("Sucesso: Achei a funcao recebe_dano!");
		        alvo.recebe_dano(dano, x, skill_id);
		    } 
		    else 
		    {
				show_debug_message("AVISO: Objeto " + object_get_name(alvo.object_index) + " NAO tem a funcao recebe_dano.");
		        // Fallback para objetos sem cérebro (tipo o dummy)
		        alvo.vida_atual -= dano;
		        if (variable_instance_exists(alvo, "estado")) {
		             alvo.estado = "hit";
		             alvo.image_index = 0;
		        }
		    }

        var morreu = (alvo.vida_atual <= 0);

        // XP skill
        if (skill_id != "")
        {
            var sc = instance_find(obj_skill_controller, 0);
            if (sc != noone) sc.grant_xp_on_hit(skill_id, alvo, morreu);
        }

      

        // número de dano
        var base_x = alvo.x;
        var base_y = alvo.y - (alvo.sprite_height / 2);
        var num = instance_create_layer(base_x, base_y, layer, obj_dano_num);
        num.texto = string(dano);
        num.cor = (alvo.object_index == obj_dummy) ? c_white : c_orange;
    }

    // agenda próximo tick (ms)
    var ms = (tick_frames * 1000) / room_speed;
    tick_map[? k] = f + ms;

    // morte do inimigo
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
