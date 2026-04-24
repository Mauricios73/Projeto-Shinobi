/// obj_skill_fire_breath - Step (compat + safe assets)

if (!instance_exists(owner)) { instance_destroy(); exit; }

// Se o player sair do estado por qualquer motivo externo, limpa tudo
if (owner.estado != "fire_breath")
{
    if (instance_exists(owner.fire_hitbox)) {
        instance_destroy(owner.fire_hitbox);
        owner.fire_hitbox = noone;
    }
    instance_destroy();
    exit;
}

var sc = instance_find(obj_skill_controller, 0);
var lvl = (sc != noone) ? sc.fire_breath.level : 1;

// 1. Lógica de escala e posicionamento (Seguindo o Player)
var scale = clamp(1 + 0.08 * (lvl - 1), 1, 2.0);
image_xscale = owner.image_xscale * scale;
image_yscale = scale;

x = owner.x + (owner.image_xscale * 48); // Ajuste o 48 se necessário
y = owner.y - 54;

// 2. Gerenciamento da Hitbox (Onde estava o erro de distância)
if (!instance_exists(owner.fire_hitbox))
{
    var hb = instance_create_layer(x, y, layer, obj_hitbox);
    hb.setup_fire(owner);
    owner.fire_hitbox = hb;
}
else 
{
    // A CORREÇÃO: Força a hitbox a ficar exatamente onde o fogo está visualmente
    with (owner.fire_hitbox) 
    {
        x = other.x;
        y = other.y;
        image_xscale = other.image_xscale;
        image_yscale = other.image_yscale;
    }
}

// ==========================================================
// AQUI ENTRA O CÓDIGO DE SINCRONIZAÇÃO DA CAIXA ROSA
// ==========================================================
if (instance_exists(owner.fire_hitbox)) 
{
    with (owner.fire_hitbox) 
    {
        // A hitbox (gerenciador) segue o fogo
        x = other.x;
        y = other.y;
        image_xscale = other.image_xscale; 
        
        // A caixa rosa (obj_dano) segue a hitbox e herda a escala
        if (instance_exists(damage_inst)) 
        {
            damage_inst.x = x;
            damage_inst.y = y;
            damage_inst.image_xscale = image_xscale;
            
            // CRITICAL: Força a colisão a ser via Sprite, não via raio/range
            damage_inst.range = 0; 
        }
    }
}

// 3. Finalização por fim de animação da sprite de fogo
if (image_index >= image_number - 1)
{
    if (instance_exists(owner.fire_hitbox)) {
        instance_destroy(owner.fire_hitbox);
        owner.fire_hitbox = noone;
    }

    if (sc != noone) sc.end_fire(owner);

    // Garante que o player volte ao IDLE corretamente
    with(owner) player_set_state(PST_IDLE);
    
    instance_destroy();
}