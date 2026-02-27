///// obj_lake_v3 - Draw End
//if (!surface_exists(application_surface)) exit;

//gpu_set_texfilter(false);

//var cam = view_camera[0];
//var vx  = camera_get_view_x(cam);
//var vy  = camera_get_view_y(cam);
//var vw  = camera_get_view_width(cam);
//var vh  = camera_get_view_height(cam);

//// trecho visível do lago no mundo
//var lake_x0 = x;
//var lake_x1 = x + lake_w;

//var vis_x0 = max(lake_x0, vx);
//var vis_x1 = min(lake_x1, vx + vw);
//var vis_w  = vis_x1 - vis_x0;

//if (vis_w <= 0) exit;

//var sw = ceil(vis_w);
//var sh = lake_h;

//// cria surface do reflexo só do visível
//if (!surface_exists(surf_reflect) || surf_w != sw || surf_h != sh)
//{
//    if (surface_exists(surf_reflect)) surface_free(surf_reflect);
//    surf_reflect = surface_create(sw, sh);
//    surf_w = sw;
//    surf_h = sh;
//}

//// ============================
//// 1) CAPTURA REFLEXO 1:1
//// ============================
//surface_set_target(surf_reflect);
//draw_clear(make_color_rgb(12, 28, 45)); // base água (evita “buraco preto”)

//// coords na application_surface (que agora é do tamanho da VIEW)
//var sx = floor(vis_x0 - vx);
//var sy = floor((y - lake_h) - vy);

//var srcW = sw;
//var srcH = sh;

//var appW = surface_get_width(application_surface);
//var appH = surface_get_height(application_surface);

//// --- Ajuste robusto: app_surface pode NÃO ser do tamanho da view ---
//// escala view -> app_surface
//var sx_scale = appW / vw;
//var sy_scale = appH / vh;

//var dx = 0;
//var dy = 0;

//// clamp
//if (sx < 0) { dx = -sx; srcW += sx; sx = 0; }
//if (sy < 0) { dy = -sy; srcH += sy; sy = 0; }
//if (sx + srcW > appW) srcW = appW - sx;
//if (sy + srcH > appH) srcH = appH - sy;

//if (srcW > 0 && srcH > 0)
//{
//    draw_surface_part_ext(application_surface, sx, sy, srcW, srcH,
//                          dx, dy + srcH, 1, -1, c_white, 1);
//}

//surface_reset_target();

//// ============================
//// 2) REFLEXO + ONDAS KINGDOM
//// ============================
//var t = current_time * wave_speed;

//for (var yy = 0; yy < lake_h; yy += slice_h)
//{
//    var shore = yy;

//    var gain;
//    if (shore < calm_zone_px) gain = 0;
//    else
//    {
//        var b = clamp((shore - calm_zone_px) / build_zone_px, 0, 1);
//        gain = power(b, 1.25);
//    }

//    var d = yy / lake_h;

//    var off =
//        sin(t + yy * wave_freq) * wave_amp * gain
//      + sin(t * 1.8 + yy * (wave_freq * 3.2)) * (wave_amp * 0.18) * gain
//      + sin(t * 0.55 + yy * (wave_freq * 1.1)) * (wave_amp * 0.55) * gain * d;

//    // shimmer sutil por linha (estável)
//    var n = sin((yy * 12.9898 + spark_seed) * 0.1) * 43758.5453;
//    n = n - floor(n); // 0..1
//    n = (n - 0.5);
//    off += n * shimmer_amp * gain;
//    off += sin(t * 2.2 + yy / shimmer_scale) * (shimmer_amp * 0.12) * gain;

//    // fade por profundidade (Kingdom)
//    var fade = 1 - (power(d, 1.15) * depth_fade_strength);
//    var a_ref = reflect_alpha * fade;

//    // suaviza o nascimento na margem
//    a_ref *= clamp((shore - 2) / 6, 0, 1);

//    draw_surface_part_ext(surf_reflect, 0, yy, sw, slice_h,
//                          vis_x0 + off, y + yy, 1, 1, c_white, a_ref);
//}

//// ============================
//// 3) TINTA/GRADIENTE DA ÁGUA
//// ============================
//draw_set_alpha(0.28);
//draw_rectangle_color(vis_x0, y, vis_x1, y + lake_h,
//    make_color_rgb(16, 34, 52), make_color_rgb(16, 34, 52),
//    make_color_rgb(6, 14, 24),  make_color_rgb(6, 14, 24),
//false);

//draw_set_alpha(1);

//// ============================
//// 4) DASHES (o que faltava no seu vídeo)
//// ============================
//gpu_set_blendmode(bm_add);
//draw_set_color(c_white);

//for (var i = 0; i < spark_n; i++)
//{
//    var wx = x + spark_x[i];
//    if (wx < vis_x0 || wx > vis_x1) continue;

//    var yy = spark_y[i];
//    var d = yy / lake_h;

//    // flicker leve
//    var flick = 0.75 + 0.25 * abs(sin((current_time + spark_ph[i]) * 0.004));
//    var a = spark_a[i] * (1 - d * 0.75) * flick;

//    draw_set_alpha(a);

//    var px = wx;
//    var py = y + yy;

//    draw_rectangle(px, py, px + spark_len[i], py + 1, false);
//}

//gpu_set_blendmode(bm_normal);
//draw_set_alpha(1);
//draw_set_color(c_white);

//// ============================
//// 4.5) RIPPLES DA CHUVA (Kingdom-like)
//// ============================
//gpu_set_blendmode(bm_add);
//draw_set_color(make_color_rgb(210, 225, 255));

//for (var i = 0; i < ripple_max; i++)
//{
//    if (ripple_t[i] < 0) continue;

//    var wx = ripple_x[i];
//    if (wx < vis_x0 || wx > vis_x1) continue;

//    var p = ripple_t[i] / ripple_life; // 0..1

//    // cresce e some
//    var r = lerp(1, ripple_size * ripple_str[i], p);

//    // y onde desenha (linha d’água + offset)
//    var ry = y + ripple_yoff[i];

//    // deep ripples são mais fracos
//    var a = ripple_alpha * (1 - p);
//    if (ripple_deep[i]) a *= 0.80;

//    draw_set_alpha(a);

//    // oval “pixel”
//    draw_rectangle(wx - r,         ry,     wx + r,         ry + 1, false);
//    draw_rectangle(wx - r * 0.65,  ry - 1, wx + r * 0.65,  ry,     false);
//    draw_rectangle(wx - r * 0.65,  ry + 1, wx + r * 0.65,  ry + 1, false);

//    // splash só na superfície
//    if (!ripple_deep[i] && p < 0.18)
//    {
//        draw_set_alpha(a * 0.85);
//        draw_rectangle(wx, ry - 2, wx + 1, ry - 1, false);
//    }
//}

//gpu_set_blendmode(bm_normal);
//draw_set_alpha(1);
//draw_set_color(c_white);

//// ============================
//// 5) BORDA KINGDOM (sem “corte duro”)
//// ============================
//for (var i = 0; i < 6; i++)
//{
//    var a = 0.34 - i * 0.05;
//    draw_set_alpha(a);
//    draw_set_color(make_color_rgb(8, 18, 30));
//    draw_rectangle(vis_x0, y + i, vis_x1, y + i + 1, false);
//}

//// highlights quebrados na linha d’água (bem sutil)
//gpu_set_blendmode(bm_add);
//draw_set_color(c_white);
//draw_set_alpha(0.10);

//for (var xx = vis_x0; xx < vis_x1; xx += 14)
//{
//    var h = sin(t * 1.2 + xx * 0.04) * 0.6;
//    var rnd = sin((xx + spark_seed) * 0.12) * 1000;
//    rnd = rnd - floor(rnd);

//    if (rnd > 0.55)
//    {
//        var len = 3 + floor(rnd * 6);
//        draw_rectangle(xx, y + 1 + h, xx + len, y + 2 + h, false);
//    }
//}

//gpu_set_blendmode(bm_normal);

//draw_set_alpha(1);
//draw_set_color(c_white);
//gpu_set_texfilter(false);

//// exporta (em coords de VIEW, porque app_surface agora = VIEW)
//global.lake_gui_top = floor(y - vy);
//global.lake_gui_h   = lake_h;