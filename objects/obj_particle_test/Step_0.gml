/// ========================================================
/// obj_particle_test - STEP
/// TESTE DO SISTEMA DE PARTÍCULAS
/// ========================================================

if (keyboard_check_pressed(ord("1")))
{
    particle_emit(
        x,
        y,
        obj_particle_system.PARTICLE_DUST,
        10
    );
}


if (keyboard_check_pressed(ord("2")))
{
    particle_emit(
        x,
        y,
        obj_particle_system.PARTICLE_SPARK,
        20
    );
}


if (keyboard_check_pressed(ord("3")))
{
    particle_emit(
        x,
        y,
        obj_particle_system.PARTICLE_SMOKE,
        5
    );
}


if (keyboard_check_pressed(ord("4")))
{
    particle_emit(
        x,
        y,
        obj_particle_system.PARTICLE_LEAF,
        8
    );
}