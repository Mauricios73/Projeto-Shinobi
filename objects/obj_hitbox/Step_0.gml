if (!instance_exists(owner))
{
    instance_destroy();
    exit;
}

if (config.skill_id == "fire_breath")
{
    if (owner.estado != "fire_breath")
    {
        instance_destroy();
        exit;
    }
}


// seguir owner
x = owner.x + owner.image_xscale * config.offset_x;
y = owner.y + config.offset_y;


// controlar duração genérica
if (config.duration > 0)
{
    duration--;
    if (duration <= 0)
    {
        instance_destroy();
        exit;
    }
}


// tick global
tick_timer++;

if (tick_timer < config.tick_frames) exit;

tick_timer = 0;

// detectar alvos
var lista = ds_list_create();
var range = 32; // tamanho da hitbox

var qtd = collision_rectangle_list(
    x - range,
    y - range,
    x + range,
    y + range,
    obj_entidade,
    false,
    false,
    lista,
    false
);


for (var i = 0; i < qtd; i++)
{
    var alvo = lista[| i];
    if (!instance_exists(alvo)) continue;

    // evitar aliados
    if (object_get_parent(alvo.object_index) ==
        object_get_parent(owner.object_index)) continue;

    var key = string(alvo.id);

    // limite de hits por alvo
    if (config.max_hits != -1)
    {
        var h = 0;
        if (ds_map_exists(hits_map, key))
            h = hits_map[? key];

        if (h >= config.max_hits) continue;

        hits_map[? key] = h + 1;
    }

    // aplicar dano
    if (variable_instance_exists(alvo, "vida_atual"))
    {
        alvo.vida_atual -= config.dano;

        var morreu = (alvo.vida_atual <= 0);

        // XP
        var sc = instance_find(obj_skill_controller, 0);
        if (sc != noone && config.skill_id != "")
        {
            sc.grant_xp_on_hit(config.skill_id, alvo, morreu);
        }

        // reação
        if (variable_instance_exists(alvo, "estado"))
        {
            alvo.estado = "hit";
            alvo.image_index = 0;
        }

        // número de dano
        var num = instance_create_layer(alvo.x,
                                        alvo.y - alvo.sprite_height/2,
                                        layer,
                                        obj_dano_num);

        num.texto = string(config.dano);
        num.cor = c_orange;
    }
}

ds_list_destroy(lista);
