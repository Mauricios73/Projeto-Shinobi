// ===== DRAW GUI END - OBJ_FOG =====
guiW = display_get_gui_width();
guiH = display_get_gui_height();
if (guiW <= 1) guiW = camera_get_view_width(view_camera[0]);
if (guiH <= 1) guiH = camera_get_view_height(view_camera[0]);

if (!fog_enabled) exit;

// garante surface mesmo se o Step ainda não rodou
if (!surface_exists(surf_fog))
{
    var sw_init = max(64, floor(guiW / fog_div));
    var sh_init = max(64, floor(guiH / fog_div));
    surf_fog = surface_create(sw_init, sh_init);
}

// -------- 1) monta fog na surface low-res --------
surface_set_target(surf_fog);
draw_clear_alpha(c_black, 0);

// base + gradiente
draw_set_alpha(fog_alpha_base);
draw_set_color(fog_col_bottom);
draw_rectangle(0, 0, surface_get_width(surf_fog), surface_get_height(surf_fog), false);

draw_set_alpha(fog_alpha_grad);
draw_rectangle_color(0, 0, surface_get_width(surf_fog), surface_get_height(surf_fog),
    fog_col_top, fog_col_top, fog_col_bottom, fog_col_bottom, false);

// blobs
draw_set_color(fog_col_top);
for (var i = 0; i < fog_blob_n; i++)
{
    draw_set_alpha(fog_blob_a[i]);
    draw_circle(fog_blob_x[i], fog_blob_y[i], fog_blob_r[i], false);
}

surface_reset_target();

// -------- 2) posição baseada no lago --------
var lakeY = guiH * 0.78;
if (variable_global_exists("lake_gui_top")) lakeY = global.lake_gui_top;

var y_band  = clamp(lakeY - fog_band_offset,  0, guiH - fog_band_h);
var y_floor = clamp(lakeY - fog_floor_offset, 0, guiH - fog_floor_h);

// ===== DEBUG (TEMP) =====
if (keyboard_check(vk_f10))
{
    draw_set_alpha(0.65); draw_set_color(c_red);
    draw_rectangle(0, y_band, guiW, y_band + fog_band_h, false);

    draw_set_alpha(0.45); draw_set_color(c_lime);
    draw_rectangle(0, y_floor, guiW, y_floor + fog_floor_h, false);

    draw_set_alpha(1); draw_set_color(c_white);
    draw_text(500, 140, "DEBUG FOG: band=" + string(y_band) + " floor=" + string(y_floor));
}

// -------- 3) desenha faixas (esticando low-res) --------
gpu_set_blendmode(bm_normal);
gpu_set_texfilter(true);

var sw = surface_get_width(surf_fog);
var sh = surface_get_height(surf_fog);
var xs = guiW / sw;

// faixa principal
var ys1 = fog_band_h / sh;
draw_surface_part_ext(surf_fog, 0, 0, sw, sh,
                      0, y_band, xs, ys1, c_white, 1);

// faixa do chão
var ys2 = fog_floor_h / sh;
draw_surface_part_ext(surf_fog, 0, 0, sw, sh,
                      0, y_floor, xs, ys2, c_white, 0.55);

gpu_set_texfilter(false);

// reset
draw_set_alpha(1);
draw_set_color(c_white);
