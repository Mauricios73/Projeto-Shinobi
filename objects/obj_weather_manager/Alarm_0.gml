// obj_weather_manager - Alarm 0

var rn = room_get_name(room);
var is_menu = false;
for (var i = 0; i < array_length(menu_rooms); i++) if (rn == menu_rooms[i]) { is_menu = true; break; }

var is_indoor = false;
for (var j = 0; j < array_length(indoor_rooms); j++) if (rn == indoor_rooms[j]) { is_indoor = true; break; }
var outdoor = !is_menu && !is_indoor;

if (is_menu)
{
    if (instance_exists(obj_fog)) with (obj_fog) instance_destroy();
    if (instance_exists(obj_neve)) with (obj_neve) instance_destroy();
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
    exit;
}

var fog_allowed = outdoor || fog_in_indoor;
if (fog_on && fog_allowed)
{
    if (!instance_exists(obj_fog)) instance_create_depth(0, 0, -2000, obj_fog);
    else obj_fog.is_fading_out = false;
}

if (!outdoor)
{
    if (instance_exists(obj_neve)) with (obj_neve) instance_destroy();
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
    exit;
}

// A chuva precisa ficar ACIMA do background e dos elementos de cenario.
// Depth menor/mais negativo pode colocar a chuva atras de fundos dependendo
// da room. Ao entrar/sair de Room2, recriamos a instancia em depth 0 para
// garantir que ela seja desenhada como overlay do ambiente.
var rain_depth = 0;

if (precip_mode == WEATHER_SNOW)
{
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
    if (!instance_exists(obj_neve)) instance_create_depth(0, 0, rain_depth, obj_neve);
}
else if (precip_mode == WEATHER_RAIN || precip_mode == WEATHER_STORM || precip_mode == 2 || precip_mode == 3)
{
    if (instance_exists(obj_neve)) with (obj_neve) instance_destroy();
    if (!instance_exists(obj_chuva)) instance_create_depth(0, 0, rain_depth, obj_chuva);
    else obj_chuva.depth = rain_depth;
}
else
{
    if (instance_exists(obj_neve)) with (obj_neve) instance_destroy();
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
}
