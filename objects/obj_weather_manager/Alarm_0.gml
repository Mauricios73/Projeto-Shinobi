var rn = room_get_name(room);

// -------- is_menu?
var is_menu = false;
for (var i = 0; i < array_length(menu_rooms); i++)
{
    if (rn == menu_rooms[i]) { is_menu = true; break; }
}

// -------- is_indoor?
var is_indoor = false;
for (var j = 0; j < array_length(indoor_rooms); j++)
{
    if (rn == indoor_rooms[j]) { is_indoor = true; break; }
}

var outdoor = (!is_menu && !is_indoor);

// MENU: nada pode existir
if (is_menu)
{
    if (instance_exists(obj_fog))   with (obj_fog) instance_destroy();
    if (instance_exists(obj_neve))  with (obj_neve) instance_destroy();
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
    exit;
}

// ----- FOG (pode indoor se fog_in_indoor = true)
var fog_allowed = outdoor || fog_in_indoor;

if (fog_on && fog_allowed)
{
    if (!instance_exists(obj_fog))
        instance_create_depth(0, 0, -2000, obj_fog);
}
else
{
    if (instance_exists(obj_fog)) with (obj_fog) instance_destroy();
}

// ----- PRECIP (somente outdoor)
if (!outdoor)
{
    if (instance_exists(obj_neve))  with (obj_neve) instance_destroy();
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
    exit;
}

// neve / chuva sem destruir-recriar à toa
if (precip_mode == 1)
{
    if (!instance_exists(obj_neve)) instance_create_depth(0, 0, -3000, obj_neve);
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
}
else if (precip_mode == 2 || precip_mode == 3)
{
    if (!instance_exists(obj_chuva)) instance_create_depth(0, 0, -3000, obj_chuva);
    if (instance_exists(obj_neve))  with (obj_neve) instance_destroy();
}
else
{
    if (instance_exists(obj_neve))  with (obj_neve) instance_destroy();
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
}