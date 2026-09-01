/// ========================================================
/// obj_particle_system - STEP
/// FASE 4.5 - PARTÍCULAS AMBIENTAIS
/// ========================================================

if (!particle_system_enabled)
    exit;

var dt = 1 / room_speed;

// ========================================================
// SISTEMA DE VENTO
// ========================================================

var wind_weather = 0;
var wind_intensity = 0;

if (instance_exists(obj_weather_manager))
{
    var wm = obj_weather_manager;

    wind_weather = wm.weather_current;

    wind_intensity =
        clamp(
            wm.weather_intensity,
            0,
            1
        );
}

// ========================================================
// VENTO BASE POR CLIMA
// ========================================================

if (instance_exists(obj_weather_manager))
{
    var wm = obj_weather_manager;

    switch (wind_weather)
    {
        case wm.WEATHER_CLEAR:

            wind_base = 5;

        break;


        case wm.WEATHER_CLOUDY:

            wind_base = 8;

        break;


        case wm.WEATHER_RAIN:

            wind_base =
                lerp(
                    10,
                    25,
                    wind_intensity
                );

        break;


        case wm.WEATHER_STORM:

            wind_base =
                lerp(
                    35,
                    65,
                    wind_intensity
                );

        break;


        case wm.WEATHER_SNOW:

            wind_base =
                lerp(
                    8,
                    25,
                    wind_intensity
                );

        break;
    }
}

// ========================================================
// VARIAÇÃO NATURAL
// ========================================================

wind_phase += wind_noise_speed * dt;

wind_noise =
    sin(wind_phase) * 4;

// ========================================================
// TEMPESTADE
// ========================================================

if (
    instance_exists(obj_weather_manager)
    &&
    wind_weather ==
    obj_weather_manager.WEATHER_STORM
)
{
    // A tempestade mantém o vento permanentemente ativo.

    wind_gust_timer -= dt;

    if (wind_gust_timer <= 0)
    {
        wind_gust_timer =
            random_range(
                1.5,
                3.5
            );

        wind_gust_target =
            random_range(
                15,
                35
            );
    }

    wind_target =
        wind_base +
        wind_noise +
        wind_gust_target;
}

// ========================================================
// CLIMA NORMAL
// ========================================================

else
{
    wind_gust_target =
        lerp(
            wind_gust_target,
            0,
            0.04
        );

    wind_gust_timer -= dt;

    wind_gust_next -= dt;

    if (wind_gust_next <= 0)
    {
        wind_gust_next =
            random_range(
                5,
                12
            );

        wind_gust_target =
            random_range(
                wind_gust_min,
                wind_gust_max
            );

        wind_gust_active = true;

        wind_gust_duration =
            random_range(
                0.7,
                1.8
            );

        wind_gust_timer =
            wind_gust_duration;
    }

    wind_target =
        wind_base +
        wind_noise +
        wind_gust_target;
}

// ========================================================
// TRANSIÇÃO DO VENTO
// ========================================================

wind =
    lerp(
        wind,
        wind_target,
        0.08
    );

// ========================================================
// FINAL DA RAJADA
// ========================================================

if (wind_gust_active)
{
    wind_gust_duration -= dt;

    if (wind_gust_duration <= 0)
    {
        wind_gust_active = false;
        wind_gust_target = 0;
    }
}

// ========================================================
// ESTADO GLOBAL DO VENTO
// ========================================================

global.wind = {
    enabled: true,
    current: wind,
    target: wind_target,
    gust: wind_gust_active,
    gust_strength: wind_gust_target
};


// ========================================================
// ATUALIZAR PARTÍCULAS EXISTENTES
// ========================================================

var new_particles = [];

var total = array_length(particles);

for (var i = 0; i < total; i++)
{
    var p = particles[i];

    p.life -= dt;

    if (p.life <= 0)
        continue;

    // Gravidade
    p.vy += p.gravity * dt;

    // Vento

	var particle_wind_factor = 1;

	if (variable_struct_exists(p, "wind_factor"))
	{
	    particle_wind_factor =
	        p.wind_factor;
	}

	p.vx +=
	(
	    p.wind +
	    wind * particle_wind_factor
	) * dt;

    // Movimento
    p.x += p.vx * dt;
    p.y += p.vy * dt;

    // Rotação
    p.rotation += p.rotation_speed * dt;

    // Tamanho
    p.size = lerp(
        p.size,
        p.target_size,
        0.03
    );

    // Transparência
    p.alpha = clamp(
        p.life / p.max_life,
        0,
        1
    );

    array_push(
        new_particles,
        p
    );
}

particles = new_particles;

particle_count = array_length(particles);


// ========================================================
// CLIMA
// ========================================================

if (
    automatic_particles
    &&
    environment_enabled
    &&
    instance_exists(obj_weather_manager)
)
{
    var wm = obj_weather_manager;

    var current_weather =
        wm.weather_current;

    var intensity =
        clamp(
            wm.weather_intensity,
            0,
            1
        );

    var indoor = false;

    if (variable_global_exists("environment"))
    {
        if (variable_struct_exists(
            global.environment,
            "weather"
        ))
        {
            indoor =
                global.environment.weather.indoor;
        }
    }


    // ====================================================
    // APENAS EXTERIOR
    // ====================================================

    if (!indoor)
    {
        environment_timer -= dt;


        if (environment_timer <= 0)
        {
            environment_timer =
                random_range(
                    0.08,
                    0.20
                );


            var cam =
                view_camera[0];

            var vx =
                camera_get_view_x(cam);

            var vy =
                camera_get_view_y(cam);

            var vw =
                camera_get_view_width(cam);

            var vh =
                camera_get_view_height(cam);


            // =================================================
            // TEMPESTADE
            // =================================================

            if (
                current_weather ==
                wm.WEATHER_STORM
            )
            {
                // ---------------------------------------------
                // FOLHAS
                // ---------------------------------------------

                if (
                    random(1) <
                    0.30 * intensity
                )
                {
                    particle_emit(
                        vx + random(vw),
                        vy + random(vh),
                        self.PARTICLE_LEAF,
                        1
                    );
                }


                // ---------------------------------------------
                // POEIRA / DETRITOS
                // ---------------------------------------------

                if (
                    random(1) <
                    0.15 * intensity
                )
                {
                    particle_emit(
                        vx + random(vw),
                        vy + random(vh),
                        self.PARTICLE_DUST,
                        1
                    );
                }
            }


            // =================================================
            // CHUVA
            // =================================================

            if (
                current_weather ==
                wm.WEATHER_RAIN
                ||
                current_weather ==
                wm.WEATHER_STORM
            )
            {
                // ---------------------------------------------
                // RESPINGOS
                // ---------------------------------------------

                if (
                    random(1) <
                    0.25 * intensity
                )
                {
                    particle_emit(
                        vx + random(vw),
                        vy + vh * 0.82,
                        self.PARTICLE_SPLASH,
                        1
                    );
                }
            }


            // =================================================
            // NEVE
            // =================================================

            if (
                current_weather ==
                wm.WEATHER_SNOW
            )
            {
                if (
                    random(1) <
                    0.60
                )
                {
                    particle_emit(
                        vx + random(vw),
                        vy - 5,
                        self.PARTICLE_ASH,
                        1
                    );
                }
            }
        }
    }
}


// ========================================================
// ESTADO GLOBAL
// ========================================================

global.particle.count =
    particle_count;