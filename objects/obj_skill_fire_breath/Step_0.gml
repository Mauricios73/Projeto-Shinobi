/// obj_skill_fire_breath - Step

if (!instance_exists(owner)) { instance_destroy(); exit; }

// Se o player sair do estado, limpa tudo
if (owner.estado != "fire_breath") {
    if (instance_exists(owner.fire_hitbox)) {
        instance_destroy(owner.fire_hitbox);
        owner.fire_hitbox = noone;
    }
    instance_destroy();
    exit;
}

var sc = instance_find(obj_skill_controller, 0);
var lvl = (sc != noone) ? sc.fire_breath.level : 1;

// --- LÓGICA DE ESCALA ---
var scale_mult = 1 + (0.03 * (lvl - 1)); 
image_xscale = owner.image_xscale * scale_mult;
image_yscale = scale_mult;

// --- POSICIONAMENTO FIXO (A SOLUÇÃO) ---
// Remova a multiplicação da escala no deslocamento. 
// O valor "12" (ou o que melhor se ajustar) será a distância FIXA da boca.
// Como o Origin da Sprite é Middle Left, ela vai crescer PARA FRENTE a partir daqui.
x = owner.x + (owner.image_xscale * 12); 

// Altura fixa alinhada com a boca da sprite do player
y = owner.y - 54; 

// 2. Gerenciamento da Hitbox e Caixa Rosa
if (!instance_exists(owner.fire_hitbox)) {
    var hb = instance_create_layer(x, y, layer, obj_hitbox);
    hb.setup_fire(owner);
    owner.fire_hitbox = hb;
} else {
    with (owner.fire_hitbox) {
        x = other.x;
        y = other.y;
        image_xscale = other.image_xscale;
        image_yscale = other.image_yscale;
        
        if (instance_exists(damage_inst)) {
            damage_inst.x = x;
            damage_inst.y = y;
            damage_inst.image_xscale = image_xscale;
            damage_inst.image_yscale = image_yscale;
            damage_inst.range = 0; 
        }
    }
}

// 3. Finalização por animação
if (image_index >= image_number - 1) {
    if (instance_exists(owner.fire_hitbox)) {
        instance_destroy(owner.fire_hitbox);
        owner.fire_hitbox = noone;
    }
    if (sc != noone) sc.end_fire(owner);
    with(owner) player_set_state(PST_IDLE);
    instance_destroy();
}