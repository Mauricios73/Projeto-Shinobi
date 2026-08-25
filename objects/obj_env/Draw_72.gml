///// obj_env - Draw Begin

// ----------------------------------------------------
// 1) CAMERA
// ----------------------------------------------------
camx = 0; camy = 0; camw = room_width; camh = room_height;

if (use_camera) {
    var cam = view_camera[0];
    camx = camera_get_view_x(cam);
    camy = camera_get_view_y(cam);
    camw = camera_get_view_width(cam);
    camh = camera_get_view_height(cam);
}

var ground_cut_screen = camh * ground_cut_ratio;

// ----------------------------------------------------
// 2) HELPERS
// ----------------------------------------------------
function smooth01(x) { x = clamp(x,0,1); return x*x*(3 - 2*x); }

// ----------------------------------------------------
// 3) FUNÇÕES DE DESENHO
// ----------------------------------------------------
function draw_sky_fullscreen(_spr, _alpha) {
    if (!sprite_exists(_spr)) return;
    var oa = draw_get_alpha();
    var oc = draw_get_color();
    draw_set_alpha(_alpha);
    draw_set_color(c_white);
    draw_sprite_stretched(_spr, 0, camx, camy, camw, camh);
    draw_set_color(oc);
    draw_set_alpha(oa);
}

function draw_tiled(_spr, _px, _py, _alpha) {
    if (!sprite_exists(_spr)) return;
    var sw = sprite_get_width(_spr);
    var sh = sprite_get_height(_spr);
    var offx = -((camx * _px)) mod sw;
    var offy = -((camy * _py)) mod sh;
    var startx = camx + offx - sw;
    var starty = camy + offy - sh;
    var endx = camx + camw + sw;
    var endy = camy + camh + sh;
    var oa = draw_get_alpha();
    var oc = draw_get_color();
    draw_set_alpha(_alpha);
    draw_set_color(c_white);
    for (var xx = startx; xx < endx; xx += sw)
    for (var yy = starty; yy < endy; yy += sh)
        draw_sprite(_spr, 0, xx, yy);
    draw_set_color(oc);
    draw_set_alpha(oa);
}

function draw_band(_spr, _px, _y_screen, _driftx, _alpha, _tint) {
    if (!sprite_exists(_spr)) return;
    var sw = sprite_get_width(_spr);
    var base_x = (camx - (camx * _px) + _driftx) mod sw;
    var yy = camy + _y_screen;
    var start_x = camx - base_x - sw;
    var end_x   = camx + camw + sw;
    var oa = draw_get_alpha();
    var oc = draw_get_color();
    draw_set_alpha(_alpha);
    draw_set_color(_tint ? ambient_col : c_white);
    for (var xx = start_x; xx < end_x; xx += sw)
        draw_sprite(_spr, 0, xx, yy);
    draw_set_color(oc);
    draw_set_alpha(oa);
}

function draw_parallax_single_center(_spr, _px, _x_center_screen, _y_screen, _alpha, _tint) {
    if (!sprite_exists(_spr)) return;
    var sw = sprite_get_width(_spr);
    var x_left_screen = _x_center_screen - (sw * 0.5);
    var sx = camx + x_left_screen - (camx * _px);
    var sy = camy + _y_screen;
    var oa = draw_get_alpha();
    var oc = draw_get_color();
    draw_set_alpha(_alpha);
    draw_set_color(_tint ? ambient_col : c_white);
    draw_sprite(_spr, 0, sx, sy);
    draw_set_color(oc);
    draw_set_alpha(oa);
}

// ----------------------------------------------------
// 4) SELEÇÃO DO CÉU
// ----------------------------------------------------
var skyA, skyB, skyMix;
var H_SUNSET = 17.0;
var H_DUSK   = 18.5;
var H_NIGHT  = 20.0;
var H_DAWN   = 5.0;
var H_MORNING = 7.0;

if (global.environment.time.hours < H_SUNSET && global.environment.time.hours >= H_MORNING) {
    skyA = sprSkyDay; skyB = sprSkyDay; skyMix = 0;
}
else if (global.environment.time.hours >= H_SUNSET && global.environment.time.hours < H_DUSK) {
    skyA = sprSkyDay; skyB = sprSkySunset; skyMix = smooth01((global.environment.time.hours - H_SUNSET) / (H_DUSK - H_SUNSET));
}
else if (global.environment.time.hours >= H_DUSK && global.environment.time.hours < H_NIGHT) {
    skyA = sprSkySunset; skyB = sprSkyDusk; skyMix = smooth01((global.environment.time.hours - H_DUSK) / (H_NIGHT - H_DUSK));
}
else if (global.environment.time.hours >= H_NIGHT || global.environment.time.hours < H_DAWN) {
    skyA = sprSkyNight; skyB = sprSkyNight; skyMix = 0;
}
else {
    skyA = sprSkyNight; skyB = sprSkyDay; skyMix = smooth01((global.environment.time.hours - H_DAWN) / (H_MORNING - H_DAWN));
}

// ----------------------------------------------------
// 5) DRAWS
// ----------------------------------------------------
draw_sky_fullscreen(skyA, 1.0);
if (skyMix > 0) draw_sky_fullscreen(skyB, skyMix);

var y_land = camh * land_far_y_ratio;
var x_center = camw * 0.5;
draw_parallax_single_center(sprLandscapeFar, land_far_px, x_center, y_land, land_far_alpha, true);

var useStars = (night_factor > 0.65) ? sprStarsB : sprStarsA;
draw_tiled(useStars, 0.03, 0.00, stars_alpha);

// ====================================================
// DRAW 3 — LUA
// ====================================================
var moonSpr = sprMoonWhite;
if (moon_mode == 1) moonSpr = sprMoonBlue;
if (moon_mode == 2) moonSpr = sprMoonRed;

if (sprite_exists(moonSpr) && moon_alpha > 0)
{
    var moon_start_x_pct = -0.5;
    var moon_end_x_pct   = 0.85;
    var start_moon_h = 18.5;
    var end_moon_h   = 5.5;
    var moon_progress;

    if (global.environment.time.hours >= start_moon_h)
        moon_progress = (global.environment.time.hours - start_moon_h) / (24 - start_moon_h + end_moon_h);
    else
        moon_progress = (global.environment.time.hours + (24 - start_moon_h)) / (24 - start_moon_h + end_moon_h);

    moon_progress = clamp(moon_progress, 0, 1);
    var moon_screen_x = lerp(camw * moon_start_x_pct, camw * moon_end_x_pct, moon_progress);
    var max_arc_height = camh * 0.75;
    var moon_screen_y  = (camh * 0.55) - sin(moon_progress * pi) * max_arc_height;
    var sx = camx + moon_screen_x - (camx * 0.05);
    var sy = camy + moon_screen_y;

    var oa = draw_get_alpha();
    draw_set_alpha(moon_alpha);
    var orig_x = sprite_get_width(moonSpr) * 0.5;
    var orig_y = sprite_get_height(moonSpr) * 0.5;
    draw_sprite_ext(moonSpr, 0, sx + orig_x, sy + orig_y, moon_scale, moon_scale, 0, c_white, moon_alpha);
    draw_set_alpha(oa);
}

// DRAW 4 — Nuvens altas
clouds_offx += 0.15;
var cloudsHigh = sprCloudHighDay;
if (global.environment.time.hours >= 16.0 && global.environment.time.hours < 19.0) cloudsHigh = sprCloudHighSun;
var y_high = camh * clouds_high_ratio;
draw_band(cloudsHigh, 0.10, y_high, clouds_offx, 0.75, false);

// DRAW 5 — Horizonte / nuvens baixas
clouds_low_offx += 0.05;
var y_low = ground_cut_screen - horizon_offset_px;
y_low = clamp(y_low, camh * 0.15, ground_cut_screen - 16);

// DRAW 6 — Overlay noite
if (night_factor > 0) {
    var oa = draw_get_alpha();
    draw_set_alpha(0.25 * night_factor);
    draw_set_color(c_black);
    draw_rectangle(camx, camy, camx + camw, camy + camh, false);
    draw_set_alpha(oa);
    draw_set_color(c_white);
}

// ====================================================
// DEBUG GUI — F5 alterna. Não altera gameplay.
// F1 pausa | F2 +1h | F3 -1h | F4 x1/x12
// ====================================================
if (time_debug && time_debug_overlay)
{
    var gh = display_get_gui_height();
    var gw = display_get_gui_width();
    var hh = floor(global.environment.time.hours);
    var mm = global.environment.time.minutes;
    var ss = global.environment.time.seconds_display;
    var clock_text = string_format(hh, 2, 0) + ":" + string_format(mm, 2, 0) + ":" + string_format(ss, 2, 0);
    var status_text = time_paused ? "PAUSADO" : "RODANDO";
    var debug_text = "ENV DEBUG  | Dia " + string(time_day) + " | " + clock_text + " | " + time_period + " | " + status_text + " | x" + string(time_scale);

    draw_set_alpha(0.86);
    draw_set_color(c_black);
    draw_rectangle(8, 8, min(gw - 8, 610), 43, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    draw_text(16, 15, debug_text);
    draw_text(16, 29, "F1 pausa | F2 +1h | F3 -1h | F4 velocidade | F5 debug");
    draw_set_color(c_white);
}
