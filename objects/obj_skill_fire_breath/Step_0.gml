/// obj_skill_fire_breath - Step (compat + safe assets)

if (!instance_exists(owner)) { instance_destroy(); exit; }

// if player not in state, cleanup hitbox and self
if (owner.estado != "fire_breath")
{
    if (variable_instance_exists(owner, "fire_hitbox") && instance_exists(owner.fire_hitbox))
    {
        with (owner.fire_hitbox) instance_destroy();
        owner.fire_hitbox = noone;
    }
    instance_destroy();
    exit;
}

// fetch skill controller instance safely
var sc = instance_find(obj_skill_controller, 0);

// defaults
var lvl = 1;
var fx_off_x = 48;
var fx_off_y = -54;

if (sc != noone)
{
    if (variable_instance_exists(sc, "fire_breath"))
    {
        lvl = sc.fire_breath.level;
        fx_off_x = sc.fire_breath.fx_offset_x;
        fx_off_y = sc.fire_breath.fx_offset_y;
    }
}

lvl = max(1, lvl);

// choose sprite by name safely (avoid undefined variables)
var spr0 = asset_get_index("spr_fire_breath");
var spr1 = asset_get_index("spr_fire_breath_1");
var spr2 = asset_get_index("spr_fire_breath_2");
var spr3 = asset_get_index("spr_fire_breath_3");

var chosen = spr0;
if (lvl >= 10 && spr3 != -1) chosen = spr3;
else if (lvl >= 5 && spr2 != -1) chosen = spr2;
else if (lvl >= 3 && spr1 != -1) chosen = spr1;

if (chosen != -1 && sprite_exists(chosen))
{
    if (sprite_index != chosen) { sprite_index = chosen; image_index = 0; image_speed = 1; }
}

// scale
var scale = 1 + 0.08 * (lvl - 1);
scale = clamp(scale, 1, 2.0);

image_xscale = owner.image_xscale * scale;
image_yscale = scale;

// position
var dir = owner.image_xscale;
x = owner.x + dir * fx_off_x;
y = owner.y + fx_off_y;

// create hitbox once
if (variable_instance_exists(owner, "fire_hitbox"))
{
    if (!instance_exists(owner.fire_hitbox))
    {
        var hb = instance_create_layer(x, y, layer, obj_hitbox);
        hb.setup_fire(owner);
        owner.fire_hitbox = hb;
    }
}

// end when animation finishes
if (image_index >= image_number - 1)
{
    if (variable_instance_exists(owner, "fire_hitbox") && instance_exists(owner.fire_hitbox))
    {
        with (owner.fire_hitbox) instance_destroy();
        owner.fire_hitbox = noone;
    }

    if (sc != noone) sc.end_fire(owner);

    owner.estado = "parado";
    instance_destroy();
}
