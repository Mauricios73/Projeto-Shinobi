// OBJ_ENTIDADE_INIMIGO- STEP BEGIN EVENT
// Herda o evento pai (Isto já deves ter no teu código)
event_inherited();

if (place_meeting(x + mid_velh, y, obj_block)){
    mid_velh *= -1;
}

// ==========================================
// CORREÇÃO: SISTEMA DE LIMPEZA DE HITBOXES
// ==========================================
// Verificamos se a entidade NÃO está a atacar
if (estado != "ataque") {
    
    // Verificamos se a variável 'dano' existe nesta entidade e se não está vazia (noone)
    if (variable_instance_exists(id, "dano") && dano != noone) {
        
        // Se a hitbox ainda existir no mundo, nós destruímo-la!
        if (instance_exists(dano)) {
            instance_destroy(dano);
        }
        
        // Limpamos as variáveis para que o próximo ataque funcione perfeitamente
        dano = noone;
        posso = true;
    }
}
// Sincroniza o pstate com a string 'estado' para o caso de scripts antigos
if (estado == "hit") pstate = PST_HIT;
if (estado == "dead") pstate = PST_DEAD;
if (estado == "parado") pstate = PST_IDLE;