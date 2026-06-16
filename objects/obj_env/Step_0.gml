///// obj_env - Step (SINCRONIZADO)

// Garante que a velocidade mude dinamicamente entre teste e jogo normal
time_speed = is_testing ? time_speed_test : time_speed_normal;

// avança tempo
t += time_speed;
if (t >= 1) t -= 1;

// helpers
function smooth01(x) { x = clamp(x,0,1); return x*x*(3 - 2*x); }
function lerp_color(c1,c2,a) { return merge_color(c1,c2, clamp(a,0,1)); }

// Pontos do ciclo
var T_SUNSET = 0.55;
var T_DUSK   = 0.70;
var T_NIGHT  = 0.82;
var T_DAWN   = 0.92;
var T_WRAP   = 1.00;

// 1) night_factor
var up   = smooth01((t - T_DUSK)  / (T_NIGHT - T_DUSK));      
var hold = (t >= T_NIGHT && t < T_DAWN) ? 1 : 0;              
var down = 1 - smooth01((t - T_DAWN) / (T_WRAP - T_DAWN));    

night_factor = max(up, max(hold, down));

// 2) ambient_col
if (t < T_SUNSET) {
    ambient_col = col_day;
}
else if (t < T_DUSK) {
    var a = smooth01((t - T_SUNSET) / (T_DUSK - T_SUNSET));
    ambient_col = lerp_color(col_day, col_dusk, a);
}
else if (t < T_NIGHT) {
    var a = smooth01((t - T_DUSK) / (T_NIGHT - T_DUSK));
    ambient_col = lerp_color(col_dusk, col_night, a);
}
else if (t < T_DAWN) {
    ambient_col = lerp_color(col_night, col_deep, 0.5);
}
else {
    var a = smooth01((t - T_DAWN) / (T_WRAP - T_DAWN));
    ambient_col = lerp_color(col_night, col_day, a);
}

// 3) Estrelas e lua
var stars_on = smooth01((t - (T_DUSK + 0.02)) / 0.12); 
var stars_off = 1 - smooth01((t - T_DAWN) / (T_WRAP - T_DAWN));

stars_alpha = clamp(stars_on, 0, 1) * clamp(stars_off, 0, 1);
moon_alpha  = stars_alpha;

// modo lua
moon_mode = 0;
if (t > 0.78 && t < 0.82) moon_mode = 2;