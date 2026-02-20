/// obj_lake_v3 - Step

// -------- trava y no chão (sem “cair”) --------
if (auto_lock_to_ground)
{
    // usa o player se existir (troque obj_player se seu player tiver outro nome)
    var px = (instance_exists(obj_player)) ? obj_player.x : (x + lake_w * 0.5);
    var py = (instance_exists(obj_player)) ? obj_player.y : y;

    var hit = collision_line(px, py - probe_extra_up, px, py + probe_extra_down, obj_block, true, true);
    if (hit != noone)
    {
        var ground_y = hit.bbox_top;
        y = floor(ground_y + waterline_offset_px);
    }
}

// -------- anima dashes --------
var dt = 1 / room_speed;

for (var i = 0; i < spark_n; i++)
{
    spark_x[i] += spark_spd[i] * dt;

    // wrap
    if (spark_x[i] < 0)      spark_x[i] += lake_w;
    else if (spark_x[i] > lake_w) spark_x[i] -= lake_w;
}