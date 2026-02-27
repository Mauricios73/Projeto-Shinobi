/// obj_sensor_interact - Create
key = vk_space;
require_press = true;

// você configura no editor:
// destino (room)
// spawn_side ("left" ou "right")
// spawn_margin (ex: 64)
if (!variable_instance_exists(id, "spawn_margin")) spawn_margin = 64;
if (!variable_instance_exists(id, "spawn _side")) spawn_side = "none";