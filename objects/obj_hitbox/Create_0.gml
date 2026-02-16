owner = noone;
config = undefined;

tick_timer = 0;
duration = 0;

tick_map = ds_map_create();   // controla próximo tick por alvo
hits_map = ds_map_create();   // controla limite de hits por alvo

debug_name = "";


function setup(_owner, _config)
{
    owner = _owner;
    config = _config;

    duration = config.duration;
    debug_name = config.skill_id;
}

function setup_chidori(_player)
{
    var sc = instance_find(obj_skill_controller, 0);

    var dmg = _player.ataque;

    if (sc != noone)
    {
        dmg += (sc.chidori.level - 1) * sc.chidori.dmg_bonus_per_level;
    }

    setup(_player, {
        skill_id     : "chidori",
        dano         : dmg,
        tick_frames  : 2,
        max_hits     : -1,
        offset_x     : 55,
        offset_y     : -42,
        duration     : 20
    });
}

function setup_fire(_player)
{
    var sc = instance_find(obj_skill_controller, 0);

    var dmg = 1;

    if (sc != noone)
    {
        dmg = sc.fire_breath.damage_base + (sc.fire_breath.level - 1);
    }

    setup(_player, {
        skill_id     : "fire_breath",
        dano         : dmg,
        tick_frames  : 1,
        max_hits     : 5,
        offset_x     : 48,
        offset_y     : -54,
        duration     : -1,     // 🔥 duração infinita
        size         : 48
    });
}
	
