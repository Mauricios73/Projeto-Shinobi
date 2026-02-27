/// obj_sensor_auto - Step
if (cooldown > 0) { cooldown--; exit; }

if (!place_meeting(x, y, obj_player)) exit;
if (instance_exists(obj_transicao)) exit;

var tran = instance_create_layer(0, 0, layer, obj_transicao);
tran.destino = destino;

tran.spawn_side = spawn_side;
tran.spawn_margin = spawn_margin;

tran.keep_y = true;
tran.spawn_y = obj_player.y;

cooldown = cooldown_max;