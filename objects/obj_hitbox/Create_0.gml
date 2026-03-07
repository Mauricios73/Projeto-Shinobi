owner = noone;
config = undefined;
duration = 0;

damage_inst = noone;

function setup(_owner, _config)
{
    owner = _owner;
    config = _config;
    duration = config.duration;
}

function setup_chidori(_player)
{
    var sc = instance_find(obj_skill_controller, 0);

    var dmg = _player.ataque;
    if (sc != noone)
        dmg += (sc.chidori.level - 1) * sc.chidori.dmg_bonus_per_level;

    setup(_player, {
        skill_id    : "chidori",
        dano        : dmg,
        tick_frames : 2,
        max_hits    : -1,
        offset_x    : 55,
        offset_y    : -42,
        duration    : 20,
        size        : 32,
        shape       : 0
    });
}

function setup_fire(_player)
{
    var sc = instance_find(obj_skill_controller, 0);

    var dmg = 1;
    if (sc != noone)
        dmg = sc.fire_breath.damage_base + (sc.fire_breath.level - 1);

    setup(_player, {
        skill_id    : "fire_breath",
        dano        : dmg,
        tick_frames : 1,
        max_hits    : 5,
        offset_x    : 48,
        offset_y    : -54,
        duration    : -1,
        size        : 48,
        shape       : 0
    });
}
