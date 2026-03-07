if (!instance_exists(owner))
{
    instance_destroy();
    exit;
}

if (is_struct(config) && variable_struct_exists(config, "skill_id") && config.skill_id == "fire_breath")
{
    if (owner.estado != "fire_breath")
    {
        instance_destroy();
        exit;
    }
}

x = owner.x + owner.image_xscale * config.offset_x;
y = owner.y + config.offset_y;

if (config.duration > 0)
{
    duration--;
    if (duration <= 0)
    {
        instance_destroy();
        exit;
    }
}

if (!instance_exists(damage_inst))
{
    damage_inst = instance_create_layer(x, y, layer, obj_dano);
    damage_inst.persistente = true;
    damage_inst.morrer = false;
}

damage_inst.x = x;
damage_inst.y = y;

damage_inst.pai = owner;
damage_inst.dano = config.dano;
damage_inst.tick_frames = config.tick_frames;
damage_inst.max_hits_por_alvo = config.max_hits;
damage_inst.skill_id = config.skill_id;

var r = 32;
if (is_struct(config) && variable_struct_exists(config, "size")) r = config.size;
damage_inst.range = r;

// shape (0=rect, 1=circle)
var sh = 0;
if (is_struct(config) && variable_struct_exists(config, "shape"))
{
    var cs = config.shape;
    if (is_string(cs) && cs == "circle") sh = 1;
    else if (is_real(cs) && cs == 1) sh = 1;
}
damage_inst.shape = sh;