/// obj_sensor_auto - Create
cooldown = 0;
cooldown_max = 20;

// você configura no editor:
// destino (room)
// spawn_side ("left" ou "right")
// spawn_margin (ex: 64)
if (!variable_instance_exists(id, "spawn_margin")) spawn_margin = 64;
if (!variable_instance_exists(id, "spawn_side")) spawn_side = "none";