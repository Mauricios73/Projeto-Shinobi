// =====================================================================
// Arquivo / Objeto: obj_sensor_interact
// Evento: Step
// =====================================================================

if (!place_meeting(x, y, obj_player)) exit;

var ok = require_press ? keyboard_check_pressed(key) : keyboard_check_released(key);
if (!ok) exit;

if (instance_exists(obj_transicao)) exit;

var tran = instance_create_layer(0, 0, layer, obj_transicao);
tran.destino = destino;

// Repassa as coordenadas X e Y configuradas na instância
tran.target_x = destino_x;
tran.target_y = destino_y;