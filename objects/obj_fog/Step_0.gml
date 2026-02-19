// Atualiza caso GUI mude
guiW = display_get_gui_width();
guiH = display_get_gui_height();
if (guiW <= 1) guiW = camera_get_view_width(view_camera[0]);
if (guiH <= 1) guiH = camera_get_view_height(view_camera[0]);

// cria/recria surface low-res
var sw = max(64, floor(guiW / fog_div));
var sh = max(64, floor(guiH / fog_div));

if (!surface_exists(surf_fog)
|| surface_get_width(surf_fog) != sw
|| surface_get_height(surf_fog) != sh)
{
    if (surface_exists(surf_fog)) surface_free(surf_fog);
    surf_fog = surface_create(sw, sh);

    // reinicia blobs dentro do low-res
    for (var i = 0; i < fog_blob_n; i++)
    {
        fog_blob_x[i]   = random(sw);
        fog_blob_y[i]   = random(sh);
        fog_blob_r[i]   = random_range(sh * 0.12, sh * 0.40);
        fog_blob_spd[i] = random_range(-0.18, -0.05);
        fog_blob_a[i]   = random_range(0.04, 0.11);
    }
}

// vento suave
var wind = 0.25 + sin(current_time * wind_speed) * wind_amp;

// Move fog blobs (igual o seu)
var sw2 = surface_get_width(surf_fog);
for (var i = 0; i < fog_blob_n; i++)
{
    fog_blob_x[i] += fog_blob_spd[i] - (wind * 0.08);
    if (fog_blob_x[i] < -fog_blob_r[i]) fog_blob_x[i] = sw2 + fog_blob_r[i];
}
