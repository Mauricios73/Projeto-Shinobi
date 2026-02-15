// ==========================
// SKILL: FIRE BREATH
// ==========================

fire_breath = {
    id: "fire_breath",
    
    // Progressão
    level: 1,
    xp: 0,
    xp_next: 20,
    unlocked: true,
    
    // Energia
   // min_start_energy: 10,
    energy_cost: 25,
    
    // Cooldown
    cooldown_max: 60, // 1 segundo se room_speed = 60
    cooldown_left: 0,
    
    // Combate
    damage_base: 1,
   // tick_time: 0.12,
    
	is_active: false,
	 
	fx_offset_x: 48,
    fx_offset_y: -54,
	
	// XP tuning (difícil de upar)
	xp_dummy_chance: 30,        // 15%
	xp_dummy_amount: 1,         // +1 quando cair
	xp_enemy_kill: 3,           // bônus ao matar (opcional)
};

chidori = {
    id: "chidori",

    level: 1,
    xp: 0,
    xp_next: 20,
    unlocked: true,

    // dano do chidori (você pode somar com ataque base também)
    dmg_bonus_per_level: 2,
	energy_cost: 25,

    // XP tuning
	xp_dummy_chance: 15,        // 15%
	xp_dummy_amount: 1,         // +1 quando cair
	xp_enemy_kill: 3,           // bônus ao matar (opcional)
};



#region functions
function add_xp(_skill_id, _amount)
{
    if (_amount <= 0) return;

    var s;
    switch (_skill_id)
    {
        case "fire_breath": s = fire_breath; break;
		case "chidori": s = chidori; break;
        default: return;
    }

    s.xp += _amount;

    // Level up em loop (caso ganhe muito XP de uma vez)
    while (s.xp >= s.xp_next)
    {
        s.xp -= s.xp_next;
        s.level += 1;

        // curva simples: cresce 35% por level
        s.xp_next = ceil(s.xp_next * 1.35);

        // opcional: buff por level
        // (não mexe no base, você pode usar level como multiplicador na skill)
    }

    // escreve de volta (porque s é cópia)
    if (_skill_id == "fire_breath") fire_breath = s;
	if (_skill_id == "chidori") chidori = s;
}

function grant_xp_on_hit(_skill_id, _target, _was_kill)
{
    // pega a skill
    var s;
    switch (_skill_id)
    {
        case "fire_breath": s = fire_breath; break;
        case "chidori":     s = chidori; break;
        default: return;
    }

    var xp_gain = 0;

    // Dummy (treino): 15% chance de +1
    if (_target.object_index == obj_dummy)
    {
        // troca sprite hit do dummy (3 variações)
        if (variable_instance_exists(_target, "hit_index"))
            _target.hit_index = irandom(2);

        // "dado" de XP
        if (irandom(99) < s.xp_dummy_chance)
            xp_gain = s.xp_dummy_amount; // geralmente 1
    }
    else
    {
        // Inimigo normal: XP fixo e pequeno
        //xp_gain = s.xp_enemy_hit;
        if (_was_kill) xp_gain += s.xp_enemy_kill;
    }

    if (xp_gain > 0) add_xp(_skill_id, xp_gain);
}


function can_use_fire(_player)
{
    if (!fire_breath.unlocked) return false;
    if (fire_breath.cooldown_left > 0) return false;
    if (fire_breath.is_active) return false;
    if (_player.energia < fire_breath.energy_cost) return false;

    return true;
}

function start_fire(_player)
{
    if (fire_breath.is_active) return;
    if (instance_exists(_player.fire_instance)) return; // trava duplicação

    fire_breath.is_active = true;

    _player.energia -= fire_breath.energy_cost;
    _player.energia = clamp(_player.energia, 0, _player.energia_max);

    // cria o efeito e já seta owner no mesmo frame
    var fx = instance_create_layer(_player.x, _player.y, _player.layer, obj_skill_fire_breath);
    fx.owner = _player;
    _player.fire_instance = fx;

    fire_breath.cooldown_left = fire_breath.cooldown_max;
}

function end_fire(_player)
{
    fire_breath.is_active = false;

    if (instance_exists(_player.fire_instance))
    {
        with (_player.fire_instance) instance_destroy();
        _player.fire_instance = noone;
    }
}
#endregion
