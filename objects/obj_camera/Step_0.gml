if (alvo == noone) exit;

x = lerp(x, alvo.x, .1);
y = lerp(y, alvo.y, .1);

/// obj_camera - Step (exemplo Kingdom-like)
// ===== FIX: application_surface no tamanho da VIEW (base 960x540) =====
var cam = view_camera[0];
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);

if (surface_exists(application_surface))
{
    if (surface_get_width(application_surface) != vw
    ||  surface_get_height(application_surface) != vh)
    {
        surface_resize(application_surface, vw, vh);
    }
}

// pixel perfect
gpu_set_texfilter(false);