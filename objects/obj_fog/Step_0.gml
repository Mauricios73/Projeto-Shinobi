guiW = display_get_gui_width();
guiH = display_get_gui_height();

if (guiW <= 1) guiW = camera_get_view_width(view_camera[0]);
if (guiH <= 1) guiH = camera_get_view_height(view_camera[0]);

var sw = max(64, floor(guiW / fog_div));
var sh = max(64, floor(guiH / fog_div));

if (!surface_exists(surf_fog)
|| surface_get_width(surf_fog) != sw
|| surface_get_height(surf_fog) != sh)
{
    if (surface_exists(surf_fog)) surface_free(surf_fog);
    surf_fog = surface_create(sw, sh);
}
