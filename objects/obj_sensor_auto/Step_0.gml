// =====================================================================
// Arquivo / Objeto: obj_sensor_auto
// Evento: Step
// =====================================================================

// Se o cooldown estiver ativo, diminui e sai do código
if (cooldown > 0) { 
    cooldown--; 
    exit; 
}

// Se o player NÃO estiver tocando neste sensor, sai do código
if (!place_meeting(x, y, obj_player)) exit;

// Se já existir uma transição rolando, ignora para não criar duas
if (instance_exists(obj_transicao)) exit;

// Cria a transição e passa os dados exatos de destino
var tran = instance_create_layer(0, 0, layer, obj_transicao);
tran.destino = destino;
tran.target_x = destino_x;
tran.target_y = destino_y;

// Reseta o cooldown para evitar bugs se o player nascer em cima de outro sensor
cooldown = cooldown_max;