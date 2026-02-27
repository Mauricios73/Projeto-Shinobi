/// obj_sensor_interact - Step
if (!place_meeting(x, y, obj_player)) exit;

var ok = require_press ? keyboard_check_pressed(key) : keyboard_check_released(key);
if (!ok) exit;

if (instance_exists(obj_transicao)) exit;

var tran = instance_create_layer(0, 0, layer, obj_transicao);
tran.destino = destino;

tran.spawn_side = spawn_side;
tran.spawn_margin = spawn_margin;

tran.keep_y = true;
tran.spawn_y = obj_player.y;