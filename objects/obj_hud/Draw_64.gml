var p = instance_find(obj_player, 0);
if (p == noone) exit;

// ---------------- helpers ----------------
function draw_bar(_x, _y, _w, _h, _pct, _col_fill, _label, _txt) {
    _pct = clamp(_pct, 0, 1);

    draw_set_alpha(0.55);
    draw_set_color(col_bg);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);

    draw_set_alpha(0.9);
    draw_set_color(_col_fill);
    draw_rectangle(_x + 2, _y + 2, _x + 2 + (_w - 4) * _pct, _y + _h - 2, false);

    draw_set_alpha(1);
    draw_set_color(col_fg);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);

    draw_set_color(col_fg);
    draw_text(_x, _y - 18, _label);

    draw_set_color(col_dim);
    draw_text(_x + _w + 10, _y + 2, _txt);
}
function yn(v) { return v ? "YES" : "NO"; }

draw_set_font(dbg_font);

// ---------------- HUD: vida/chakra ----------------
var x0 = pad;
var y0 = pad;

var hp = 0, hpmax = 1;
var mp = 0, mpmax = 1;

if (variable_instance_exists(p, "vida_atual")) hp = p.vida_atual;
if (variable_instance_exists(p, "vida_max"))   hpmax = p.vida_max;

if (variable_instance_exists(p, "energia"))     mp = p.energia;
if (variable_instance_exists(p, "energia_max")) mpmax = p.energia_max;

hpmax = max(hpmax, 1);
mpmax = max(mpmax, 1);

draw_bar(x0, y0, 260, 18, hp / hpmax, col_red, "VIDA", string(floor(hp)) + " / " + string(floor(hpmax)));
y0 += 34;

draw_bar(x0, y0, 260, 18, mp / mpmax, col_blue, "CHAKRA", string(floor(mp)) + " / " + string(floor(mpmax)));
y0 += 40;

// ---------------- Cooldowns (player) ----------------
draw_set_color(col_fg);
draw_text(x0, y0, "COOLDOWNS");
y0 += 20;

// Dash
var dash_t = (variable_instance_exists(p, "dash_timer")) ? p.dash_timer : -1;
var dash_d = (variable_instance_exists(p, "dash_delay")) ? p.dash_delay : -1;

if (dash_t >= 0 && dash_d > 0) {
    var pct_dash = 1 - (dash_t / dash_d);
    draw_bar(x0, y0, 260, 14, pct_dash, col_yel, "DASH", "timer: " + string(dash_t));
    y0 += 26;
} else {
    draw_set_color(col_dim);
    draw_text(x0, y0, "DASH: (sem vars dash_timer/dash_delay)");
    y0 += 20;
}

// Chidori CD (player)
var chi_cd  = (variable_instance_exists(p, "chidori_cd")) ? p.chidori_cd : -1;
var chi_max = (variable_instance_exists(p, "chidori_cd_max")) ? p.chidori_cd_max : -1;

if (chi_cd >= 0 && chi_max > 0) {
    var pct_chi = 1 - (chi_cd / chi_max);
    draw_bar(x0, y0, 260, 14, pct_chi, col_grn, "CHIDORI", "cd: " + string(chi_cd));
    y0 += 26;
} else {
    draw_set_color(col_dim);
    draw_text(x0, y0, "CHIDORI CD: (sem vars chidori_cd/chidori_cd_max)");
    y0 += 20;
}

// Fire CD (player) — opcional
var fire_cd  = (variable_instance_exists(p, "fire_cd")) ? p.fire_cd : -1;
var fire_max = (variable_instance_exists(p, "fire_cd_max")) ? p.fire_cd_max : -1;

if (fire_cd >= 0 && fire_max > 0) {
    var pct_fire = 1 - (fire_cd / fire_max);
    draw_bar(x0, y0, 260, 14, pct_fire, col_blue, "FIRE BREATH", "cd: " + string(fire_cd));
    y0 += 26;
} else {
    draw_set_color(col_dim);
    draw_text(x0, y0, "FIRE CD (player): (sem vars fire_cd/fire_cd_max)");
    y0 += 20;
}

// ---------------- DEBUG overlay ----------------
if (dbg_show)
{
    var dbg_x = pad;
    var dbg_y = y0 + 10;

    var box_w = 600;
    var box_h = 360;

    draw_set_alpha(0.55);
    draw_set_color(col_bg);
    draw_rectangle(dbg_x, dbg_y, dbg_x + box_w, dbg_y + box_h, false);

    draw_set_alpha(1);
    draw_set_color(col_fg);
    draw_rectangle(dbg_x, dbg_y, dbg_x + box_w, dbg_y + box_h, true);

    dbg_x += 10;
    dbg_y += 10;

    draw_set_color(col_fg);
    draw_text(dbg_x, dbg_y, "DEBUG (F3 alterna)  |  Room: " + string(room_get_name(room)) + "  |  FPS: " + string(fps_real));
    dbg_y += 22;

    // -------- PLAYER --------
    var st  = variable_instance_exists(p, "estado") ? p.estado : "<sem estado>";
    var vh  = variable_instance_exists(p, "velh") ? p.velh : 0;
    var vv  = variable_instance_exists(p, "velv") ? p.velv : 0;
    var mvh = variable_instance_exists(p, "mid_velh") ? p.mid_velh : 0;

    var og  = variable_instance_exists(p, "on_ground") ? p.on_ground : place_meeting(p.x, p.y + 1, obj_block);
    var wog = variable_instance_exists(p, "was_on_ground") ? p.was_on_ground : false;
    var landed = (!wog && og);

    var da = variable_instance_exists(p, "dash_aereo") ? p.dash_aereo : -1;
    var ca = variable_instance_exists(p, "chidori_aereo") ? p.chidori_aereo : -1;

    var inv = variable_instance_exists(p, "invencivel") ? p.invencivel : false;
    var tinv= variable_instance_exists(p, "tempo_invencivel") ? p.tempo_invencivel : -1;

    // fire status no player
    var is_fire_state = (st == "fire_breath");
    var fi_exists = false;
    if (variable_instance_exists(p, "fire_instance")) {
        fi_exists = instance_exists(p.fire_instance);
    }

    draw_set_color(col_fg);
    draw_text(dbg_x, dbg_y, "PLAYER"); dbg_y += line_h;

    draw_set_color(col_dim);
    draw_text(dbg_x, dbg_y, "estado: " + string(st)); dbg_y += line_h;
    draw_text(dbg_x, dbg_y, "pos: x=" + string(floor(p.x)) + " y=" + string(floor(p.y))); dbg_y += line_h;
    draw_text(dbg_x, dbg_y, "velh=" + string(vh) + "  mid_velh=" + string(mvh) + "  velv=" + string(vv)); dbg_y += line_h;

    draw_text(dbg_x, dbg_y, "on_ground=" + yn(og) + "  was=" + yn(wog) + "  landed=" + yn(landed)); dbg_y += line_h;
    draw_text(dbg_x, dbg_y, "dash_aereo=" + string(da) + "  chidori_aereo=" + string(ca)); dbg_y += line_h;

    draw_text(dbg_x, dbg_y, "chidori_cd=" + string(chi_cd) + " / " + string(chi_max)); dbg_y += line_h;

    draw_text(dbg_x, dbg_y, "invencivel=" + yn(inv) + "  tempo=" + string(tinv)); dbg_y += line_h;
    draw_text(dbg_x, dbg_y, "energia=" + string(floor(mp)) + "/" + string(floor(mpmax))); dbg_y += line_h;

    draw_text(dbg_x, dbg_y, "fire_state=" + yn(is_fire_state) + "  fire_instance=" + yn(fi_exists)); dbg_y += line_h;

    // -------- CONTROLLER (coluna 2) --------
    var dbg_x2 = dbg_x + 320;
    var dbg_y2 = (y0 + 10) + 32;

    var sc = instance_find(obj_skill_controller, 0);

    draw_set_color(col_fg);
    draw_text(dbg_x2, dbg_y2, "SKILL CONTROLLER"); dbg_y2 += line_h;

    if (sc == noone)
    {
        draw_set_color(col_red);
        draw_text(dbg_x2, dbg_y2, "obj_skill_controller: NÃO ENCONTRADO"); dbg_y2 += line_h;
    }
    else
    {
        // --- CHIDORI ---
        draw_set_color(col_dim);
        draw_text(dbg_x2, dbg_y2, "CHIDORI"); dbg_y2 += line_h;
        draw_text(dbg_x2, dbg_y2, "unlocked=" + yn(sc.chidori.unlocked)); dbg_y2 += line_h;
        draw_text(dbg_x2, dbg_y2, "level=" + string(sc.chidori.level)); dbg_y2 += line_h;
        draw_text(dbg_x2, dbg_y2, "energy_cost=" + string(sc.chidori.energy_cost)); dbg_y2 += line_h;

        if (variable_instance_exists(sc.chidori, "xp")) {
            draw_text(dbg_x2, dbg_y2, "xp=" + string(sc.chidori.xp)); dbg_y2 += line_h;
        }
        if (variable_instance_exists(sc.chidori, "xp_next")) {
            draw_text(dbg_x2, dbg_y2, "xp_next=" + string(sc.chidori.xp_next)); dbg_y2 += line_h;
        }

        dbg_y2 += 8;

        // --- FIRE BREATH (CORRIGIDO: fire_breath) ---
        draw_set_color(col_dim);
        draw_text(dbg_x2, dbg_y2, "FIRE BREATH"); dbg_y2 += line_h;

        draw_text(dbg_x2, dbg_y2, "unlocked=" + yn(sc.fire_breath.unlocked)); dbg_y2 += line_h;
        draw_text(dbg_x2, dbg_y2, "level=" + string(sc.fire_breath.level)); dbg_y2 += line_h;
        draw_text(dbg_x2, dbg_y2, "energy_cost=" + string(sc.fire_breath.energy_cost)); dbg_y2 += line_h;

        draw_text(dbg_x2, dbg_y2, "cooldown=" + string(sc.fire_breath.cooldown_left) + " / " + string(sc.fire_breath.cooldown_max)); dbg_y2 += line_h;
        draw_text(dbg_x2, dbg_y2, "is_active=" + yn(sc.fire_breath.is_active)); dbg_y2 += line_h;

        if (variable_instance_exists(sc.fire_breath, "xp")) {
            draw_text(dbg_x2, dbg_y2, "xp=" + string(sc.fire_breath.xp)); dbg_y2 += line_h;
        }
        if (variable_instance_exists(sc.fire_breath, "xp_next")) {
            draw_text(dbg_x2, dbg_y2, "xp_next=" + string(sc.fire_breath.xp_next)); dbg_y2 += line_h;
        }
    }

    draw_set_color(col_yel);
    draw_text(dbg_x, (y0 + 10) + box_h - 24, "DICA: Se on_ground piscar TRUE no ar, resets ficam infinitos. Veja on_ground/landed aqui.");
}
