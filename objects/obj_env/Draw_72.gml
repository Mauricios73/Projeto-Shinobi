/// obj_env - Draw Begin

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

// “chão/água” na tela
var ground_cut_screen = camh * ground_cut_ratio;

// ----------------------------------------------------
// 2) HELPERS
// ----------------------------------------------------
function smooth01(x) { x = clamp(x,0,1); return x*x*(3 - 2*x); }

// ----------------------------------------------------
// 3) FUNÇÕES (uma por tipo de desenho)
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

function draw_screen_sprite_parallax(_spr, _x_screen, _y_screen, _px, _alpha) {
    if (!sprite_exists(_spr)) return;

    var sx = camx + _x_screen - (camx * _px);
    var sy = camy + _y_screen;

    var oa = draw_get_alpha();
    var oc = draw_get_color();

    draw_set_alpha(_alpha);
    draw_set_color(c_white);
    draw_sprite(_spr, 0, sx, sy);

    draw_set_color(oc);
    draw_set_alpha(oa);
}

function draw_parallax_single_center(_spr, _px, _x_center_screen, _y_screen, _alpha, _tint)
{
    if (!sprite_exists(_spr)) return;

    var sw = sprite_get_width(_spr);

    // Queremos que o sprite fique centralizado em _x_center_screen
    // então desenhamos em x = center - sw/2
    var x_left_screen = _x_center_screen - (sw * 0.5);

    // parallax: só responde ao camx (quando o player/câmera anda)
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
// 4) SELEÇÃO DO CÉU (sincronizado com o Step)
// ----------------------------------------------------
var skyA, skyB, skyMix;
//function smooth01(x) { x = clamp(x,0,1); return x*x*(3 - 2*x); }

var T_SUNSET = 0.55;
var T_DUSK   = 0.70;
var T_NIGHT  = 0.82;
var T_DAWN   = 0.92;
var T_WRAP   = 1.00;

// 0.00 -> 0.55  : Day fixo
// 0.55 -> 0.70  : Day -> Sunset
// 0.70 -> 0.82  : Sunset -> Dusk
// 0.82 -> 0.92  : Dusk -> Night
// 0.92 -> 1.00  : Night -> Day (Dawn)

if (t < T_SUNSET) {
    skyA = sprSkyDay;
    skyB = sprSkyDay;
    skyMix = 0;
}
else if (t < T_DUSK) {
    skyA = sprSkyDay;
    skyB = sprSkySunset;
    skyMix = smooth01((t - T_SUNSET) / (T_DUSK - T_SUNSET));
}
else if (t < T_NIGHT) {
    skyA = sprSkySunset;
    skyB = sprSkyDusk;
    skyMix = smooth01((t - T_DUSK) / (T_NIGHT - T_DUSK));
}
else if (t < T_DAWN) {
    skyA = sprSkyDusk;
    skyB = sprSkyNight;
    skyMix = smooth01((t - T_NIGHT) / (T_DAWN - T_NIGHT));
}
else {
    skyA = sprSkyNight;
    skyB = sprSkyDay;
    skyMix = smooth01((t - T_DAWN) / (T_WRAP - T_DAWN));
}

// ----------------------------------------------------
// 5) DRAWS (1 bloco por coisa)
// ----------------------------------------------------

// DRAW 1 — Céu
draw_sky_fullscreen(skyA, 1.0);
if (skyMix > 0) draw_sky_fullscreen(skyB, skyMix);

// DRAW 1.3 — Landscape 2 (mais ao fundo, MAIS alta, repete horizontalmente)
if (sprite_exists(sprLandscapeFar2))
{
    var y2 = camh * land2_y_ratio;

    // loop horizontal: repete na largura
    // drift = land2_offx (0 = totalmente parado; pode usar um valor pequeno se quiser)
    draw_band(sprLandscapeFar2, land2_px, y2, land2_offx, land2_alpha, land2_tint);
}

// DRAW 1.5 — Paisagem distante centralizada
var y_land = camh * land_far_y_ratio;
var x_center = camw * 0.5;

//draw_parallax_single_center(sprLandscapeFar, land_far_px, x_center, y_land, land_far_alpha, true);

// DRAW 2 — Estrelas
var useStars = (night_factor > 0.65) ? sprStarsB : sprStarsA;
draw_tiled(useStars, 0.03, 0.00, stars_alpha);

// DRAW 3 — Lua
var moonSpr = sprMoonWhite;
if (moon_mode == 1) moonSpr = sprMoonBlue;
if (moon_mode == 2) moonSpr = sprMoonRed;

draw_screen_sprite_parallax(moonSpr, camw * 0.70, camh * 0.12, 0.05, moon_alpha);

// DRAW 4 — Nuvens altas
clouds_offx += 0.15;

var cloudsHigh = sprCloudHighDay;
if (t >= 0.45 && t < 0.70) cloudsHigh = sprCloudHighSun;
if (t >= 0.70) cloudsHigh = sprCloudHighNight;

var y_high = camh * clouds_high_ratio;
//draw_band(cloudsHigh, 0.10, y_high, clouds_offx, 0.75, false);

// DRAW 5 — Horizonte / nuvens baixas (sempre acima do “chão/água”)
clouds_low_offx += 0.05;

// posição alvo: um pouco acima do chão
var y_low = ground_cut_screen - horizon_offset_px;

// evita ficar alto demais
y_low = clamp(y_low, camh * 0.15, ground_cut_screen - 16);

//draw_band(sprCloudLowA, 0.20, y_low, clouds_low_offx, 0.90, true);

// DRAW 6 — Overlay noite (escurecimento)
if (night_factor > 0) {
    var oa = draw_get_alpha();
    draw_set_alpha(0.25 * night_factor);
    draw_set_color(c_black);
    draw_rectangle(camx, camy, camx + camw, camy + camh, false);
    draw_set_alpha(oa);
    draw_set_color(c_white);
}