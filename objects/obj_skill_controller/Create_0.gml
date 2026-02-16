// ==========================
// SKILL: FIRE BREATH
// ==========================
fire_breath = {
    id: "fire_breath",

    level: 1,
    xp: 0,
    xp_next: 20,
    unlocked: true,

    energy_cost: 25,

    cooldown_max: 60,
    cooldown_left: 0,

    damage_base: 1,

    is_active: false,

    fx_offset_x: 48,
    fx_offset_y: -54,

    xp_dummy_chance: 7,
    xp_dummy_amount: 1,
    xp_enemy_kill: 3,
};

// ==========================
// SKILL: CHIDORI
// ==========================
chidori = {
    id: "chidori",

    level: 1,
    xp: 0,
    xp_next: 20,
    unlocked: false,   // ✅ começa bloqueado (mude se quiser)

    dmg_bonus_per_level: 2,
    energy_cost: 25,

    // ✅ cooldown
    cooldown_max: 60,
    cooldown_left: 0,

    xp_dummy_chance: 15,
    xp_dummy_amount: 1,
    xp_enemy_kill: 3,
};

#region functions

function add_xp(_skill_id, _amount)
{
    if (_amount <= 0) return;

    var s;
    switch (_skill_id)
    {
        case "fire_breath": s = fire_breath; break;
        case "chidori":     s = chidori; break;
        default: return;
    }

    s.xp += _amount;

    while (s.xp >= s.xp_next)
    {
        s.xp -= s.xp_next;
        s.level += 1;
        s.xp_next = ceil(s.xp_next * 1.35);
    }

    if (_skill_id == "fire_breath") fire_breath = s;
    if (_skill_id == "chidori")     chidori = s;
}

function grant_xp_on_hit(_skill_id, _target, _was_kill)
{
    var s;
    switch (_skill_id)
    {
        case "fire_breath": s = fire_breath; break;
        case "chidori":     s = chidori; break;
        default: return;
    }

    var xp_gain = 0;

    if (_target.object_index == obj_dummy)
    {
        if (variable_instance_exists(_target, "hit_index"))
            _target.hit_index = irandom(2);

        if (irandom(99) < s.xp_dummy_chance)
            xp_gain = s.xp_dummy_amount;
    }
    else
    {
        if (_was_kill) xp_gain += s.xp_enemy_kill;
    }

    if (xp_gain > 0) add_xp(_skill_id, xp_gain);
}

// --------------------------
// FIRE
// --------------------------
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
    if (!can_use_fire(_player)) return false;

    fire_breath.is_active = true;

    _player.energia -= fire_breath.energy_cost;
    _player.energia = clamp(_player.energia, 0, _player.energia_max);

    fire_breath.cooldown_left = fire_breath.cooldown_max;

    // 🔥 ativa estado
    _player.estado = "fire_breath";
    _player.image_index = 0;

    // 🔥 cria efeito visual
    var fx = instance_create_layer(_player.x, _player.y, _player.layer, obj_skill_fire_breath);
    fx.owner = _player;
    _player.fire_instance = fx;

    // 💥 cria hitbox profissional
    var hb = instance_create_layer(_player.x, _player.y, _player.layer, obj_hitbox);
    hb.setup_fire(_player);
    _player.fire_hit = hb;

    return true;
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

// --------------------------
// CHIDORI
// --------------------------
function can_use_chidori(_player)
{
    if (!chidori.unlocked) return false;
    if (chidori.cooldown_left > 0) return false;
    if (_player.energia < chidori.energy_cost) return false;
    return true;
}

function start_chidori(_player)
{
    if (!can_use_chidori(_player)) return false;

    // Consome energia
    _player.energia -= chidori.energy_cost;
    _player.energia = clamp(_player.energia, 0, _player.energia_max);

    // Ativa estado
    _player.estado = "chidori";
    _player.image_index = 0;

    // Cria hitbox profissional
    var hb = instance_create_layer(_player.x, _player.y, _player.layer, obj_hitbox);
    hb.setup_chidori(_player);

    _player.chidori_hit = hb;

    // Cooldown
    chidori.cooldown_left = chidori.cooldown_max;

    return true;
}

// ✅ (opcional) função pra desbloquear
function unlock_skill(_id)
{
    switch (_id)
    {
        case "chidori": chidori.unlocked = true; break;
        case "fire_breath": fire_breath.unlocked = true; break;
    }
}

#endregion
