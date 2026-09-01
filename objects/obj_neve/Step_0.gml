/// ========================================================
/// OBJ_NEVE
/// STEP
/// ========================================================

var cam = view_camera[0];

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);


// ========================================================
// INICIALIZAÇÃO DAS PARTÍCULAS
// ========================================================

if (!init)
{
    init = true;

    gw = cam_w;
    gh = cam_h;

    for (var i = 0; i < snow_n; i++)
    {
        sx[i] = random(cam_w);
        sy[i] = random_range(-cam_h, cam_h);

        ph[i] = irandom(999999);

        lay[i] =
            (i < snow_n * 0.55)
            ? 0
            : 1;


        // ------------------------------------------------
        // CAMADA DISTANTE
        // ------------------------------------------------

        if (lay[i] == 0)
        {
            sp[i] = random_range(0.25, 0.65);
            ss[i] = choose(1, 1, 1, 2);
            sa[i] = random_range(0.15, 0.35);
        }


        // ------------------------------------------------
        // CAMADA PRÓXIMA
        // ------------------------------------------------

        else
        {
            sp[i] = random_range(0.7, 1.2);
            ss[i] = choose(1, 2, 2, 3);
            sa[i] = random_range(0.35, 0.65);
        }
    }
}


// ========================================================
// VENTO
// ========================================================

var wind =
    wind_base +
    sin(current_time * wind_speed) * wind_amp;


// ========================================================
// LINHA DE POUSO
// ========================================================

var target_ratio_y = cam_h * 0.52;

if (instance_exists(obj_env))
{
    target_ratio_y =
        cam_h * obj_env.ground_cut_ratio;
}


// ========================================================
// ACÚMULO DE NEVE
// ========================================================

var altura_acumulo = 0;

if (variable_global_exists("snow_amount"))
{
    altura_acumulo =
        global.snow_amount * 10;
}


var limite_pouso =
    target_ratio_y -
    altura_acumulo;


// ========================================================
// MOVIMENTO
// ========================================================

for (var i = 0; i < snow_n; i++)
{
    var drift_strength =
        (lay[i] == 1)
        ? 0.35
        : 0.18;


    var drift =
        sin(
            (current_time + ph[i]) * 0.002 +
            sy[i] * 0.03
        ) * drift_strength;


    // Movimento horizontal
    sx[i] += wind + drift;

    // Movimento vertical
    sy[i] += sp[i];


    // ====================================================
    // TOCOU NO SOLO / ÁGUA
    // ====================================================

    if (
        sy[i] > limite_pouso ||
        sy[i] > cam_h + 10
    )
    {
        sy[i] =
            random_range(-40, -10);

        sx[i] =
            random(cam_w);
    }


    // ====================================================
    // LIMITES HORIZONTAIS
    // ====================================================

    if (sx[i] > cam_w + 8)
    {
        sx[i] = -8;
    }

    if (sx[i] < -8)
    {
        sx[i] = cam_w + 8;
    }
}