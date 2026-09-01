/// ========================================================
/// obj_particle_system - DRAW
/// FASE 4.4
/// ========================================================

if (!particle_system_enabled)
    exit;


var total =
    array_length(particles);


for (var i = 0; i < total; i++)
{
    var p = particles[i];


    draw_set_alpha(
        p.alpha
    );


    draw_set_color(
        p.color
    );


    switch (p.type)
    {
        // =================================================
        // POEIRA
        // =================================================

        case PARTICLE_DUST:

            draw_circle(
                p.x,
                p.y,
                p.size,
                false
            );

        break;


        // =================================================
        // FOLHA
        // =================================================

        case PARTICLE_LEAF:

            draw_set_alpha(
                p.alpha * 0.9
            );


            draw_ellipse(
                p.x - p.size,
                p.y - p.size * 0.5,
                p.x + p.size,
                p.y + p.size * 0.5,
                false
            );

        break;


        // =================================================
        // FAÍSCA
        // =================================================

        case PARTICLE_SPARK:

            draw_line(
                p.x,
                p.y,
                p.x - p.vx * 0.02,
                p.y - p.vy * 0.02
            );

        break;


        // =================================================
        // FUMAÇA
        // =================================================

        case PARTICLE_SMOKE:

            draw_circle(
                p.x,
                p.y,
                p.size,
                false
            );

        break;


        // =================================================
        // CINZA
        // =================================================

        case PARTICLE_ASH:

            draw_circle(
                p.x,
                p.y,
                max(1, p.size),
                false
            );

        break;


        // =================================================
        // RESPINGO
        // =================================================

        case PARTICLE_SPLASH:

            draw_line(
                p.x,
                p.y,
                p.x + p.vx * 0.04,
                p.y + p.vy * 0.04
            );

        break;


        // =================================================
        // IMPACTO
        // =================================================

        case PARTICLE_IMPACT:

            draw_circle(
                p.x,
                p.y,
                p.size,
                false
            );

        break;
    }
}


// ========================================================
// RESET
// ========================================================

draw_set_alpha(1);
draw_set_color(c_white);