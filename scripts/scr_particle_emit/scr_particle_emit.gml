/// ========================================================
/// scr_particle_emit
/// FASE 4.4
///
/// particle_emit(
///     x,
///     y,
///     type,
///     amount
/// )
/// ========================================================

function particle_emit(
    _x,
    _y,
    _type,
    _amount
)
{
    if (!instance_exists(obj_particle_system))
        return;


    var ps =
        obj_particle_system;


    var available =
        ps.particle_max -
        ps.particle_count;


    _amount =
        min(
            _amount,
            available
        );


    if (_amount <= 0)
        return;


    for (var i = 0; i < _amount; i++)
    {
        var p = {};


        // ------------------------------------------------
        // POSIÇÃO
        // ------------------------------------------------

        p.x =
            _x +
            random_range(
                -4,
                4
            );

        p.y =
            _y +
            random_range(
                -4,
                4
            );


        // ------------------------------------------------
        // TIPO
        // ------------------------------------------------

        p.type =
            _type;


        // ------------------------------------------------
        // VELOCIDADE
        // ------------------------------------------------

        p.vx =
            random_range(
                -30,
                30
            );

        p.vy =
            random_range(
                -30,
                30
            );


        // ------------------------------------------------
        // FÍSICA
        // ------------------------------------------------

        p.gravity = 0;

        p.wind = 0;
		
		p.wind_factor = 1;

        // ------------------------------------------------
        // VIDA
        // ------------------------------------------------

        p.max_life =
            random_range(
                0.4,
                1.2
            );

        p.life =
            p.max_life;


        // ------------------------------------------------
        // TAMANHO
        // ------------------------------------------------

        p.size =
            random_range(
                1,
                3
            );

        p.target_size =
            p.size;


        // ------------------------------------------------
        // ROTAÇÃO
        // ------------------------------------------------

        p.rotation =
            random(360);

        p.rotation_speed =
            random_range(
                -180,
                180
            );


        // ------------------------------------------------
        // OPACIDADE
        // ------------------------------------------------

        p.alpha = 1;


        // ------------------------------------------------
        // COR PADRÃO
        // ------------------------------------------------

        p.color =
            c_white;


        // ------------------------------------------------
        // CONFIGURAÇÃO POR TIPO
        // ------------------------------------------------

        switch (_type)
        {
			case ps.PARTICLE_DUST:

			    p.color =
			        make_color_rgb(
			            180,
			            165,
			            140
			        );

			    p.gravity = -2;

			    p.wind =
			        random_range(
			            -10,
			            10
			        );

			    p.wind_factor = 1.25;

			    p.vx =
			        random_range(
			            -15,
			            15
			        );

			    p.vy =
			        random_range(
			            -10,
			            5
			        );

			break;

            case ps.PARTICLE_LEAF:

			    p.color =
			        make_color_rgb(
			            100,
			            140,
			            70
			        );

			    p.gravity = 4;

			    p.wind =
			        random_range(
			            -35,
			            35
			        );

			    p.wind_factor = 1.5;

			    p.vx =
			        random_range(
			            -20,
			            20
			        );

			    p.vy =
			        random_range(
			            10,
			            35
			        );

			    p.max_life =
			        random_range(
			            1.5,
			            4.0
			        );

			    p.life =
			        p.max_life;

			    p.size =
			        random_range(
			            2,
			            5
			        );

			    p.target_size =
			        p.size;

			break;

            case ps.PARTICLE_SPARK:

                p.color =
                    make_color_rgb(
                        255,
                        210,
                        100
                    );

                p.gravity = 80;
				p.wind_factor = 0.15;
				
                p.max_life =
                    random_range(
                        0.15,
                        0.45
                    );

                p.life =
                    p.max_life;

            break;

            case ps.PARTICLE_SMOKE:

                p.color =
                    make_color_rgb(
                        120,
                        120,
                        120
                    );

                p.gravity = -5;
				p.wind_factor = 0.15;

                p.vx =
                    random_range(
                        -8,
                        8
                    );

                p.vy =
                    random_range(
                        -20,
                        -5
                    );

                p.size =
                    random_range(
                        3,
                        7
                    );

                p.target_size =
                    random_range(
                        10,
                        18
                    );

            break;

            case ps.PARTICLE_ASH:

                p.color =
                    make_color_rgb(
                        90,
                        90,
                        90
                    );

                p.gravity = 5;

                p.wind =
                    random_range(
                        -10,
                        10
                    );

            break;

            case ps.PARTICLE_SPLASH:

                p.color =
                    make_color_rgb(
                        170,
                        205,
                        230
                    );

                p.gravity = 100;
				p.wind_factor = 0.05;

                p.vx =
                    random_range(
                        -40,
                        40
                    );

                p.vy =
                    random_range(
                        -80,
                        -30
                    );

            break;

            case ps.PARTICLE_IMPACT:

                p.color =
                    c_white;

                p.max_life =
                    random_range(
                        0.15,
                        0.30
                    );

                p.life =
                    p.max_life;

            break;
        }


        array_push(
            ps.particles,
            p
        );
    }

    ps.particle_count =
        array_length(
            ps.particles
        );
}