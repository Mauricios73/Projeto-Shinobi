/// ============================================================
/// OBJ_ENTIDADE_PLAYER
/// STEP 2
/// SISTEMA DE MOVIMENTO + COLISÃO
/// ============================================================


// ============================================================
// RESET DOS CONTATOS
// ============================================================

on_ground   = false;
hit_ceiling = false;

wall_left  = false;
wall_right = false;


// ============================================================
// LOCK DO WALL JUMP
// ============================================================

if (wall_jump_lock > 0)
{
    wall_jump_lock--;
}


// ============================================================
// MOVIMENTO HORIZONTAL
// ============================================================

move_rem_x += velh;


// Quantidade inteira de pixels que precisamos mover
var _move_x = floor(abs(move_rem_x));


// Direção
var _dir_x = sign(move_rem_x);


// Remove a parte inteira do acumulador
move_rem_x -= _move_x * _dir_x;


// ============================================================
// RESOLUÇÃO HORIZONTAL
// ============================================================

repeat (_move_x)
{
    if (!collision_player(x + _dir_x, y))
    {
        x += _dir_x;
    }
    else
    {
        // Parede esquerda
        if (_dir_x < 0)
        {
            wall_left = true;
        }

        // Parede direita
        else
        {
            wall_right = true;
        }


        // IMPORTANTE:
        // somente o movimento horizontal é interrompido.
        //
        // NÃO zeramos velv.
        //
        // Isso permite:
        // - pular contra paredes
        // - deslizar
        // - wall jump
        // - wall climb
        // - continuar caindo

        velh = 0;
        move_rem_x = 0;

        break;
    }
}


// ============================================================
// MOVIMENTO VERTICAL
// ============================================================

move_rem_y += velv;


// Quantidade inteira de pixels
var _move_y = floor(abs(move_rem_y));


// Direção
var _dir_y = sign(move_rem_y);


// Remove parte inteira
move_rem_y -= _move_y * _dir_y;


// ============================================================
// RESOLUÇÃO VERTICAL
// ============================================================

repeat (_move_y)
{
    if (!collision_player(x, y + _dir_y))
    {
        y += _dir_y;
    }
    else
    {
        // Estamos descendo
        if (_dir_y > 0)
        {
            on_ground = true;
        }

        // Estamos subindo
        else
        {
            hit_ceiling = true;
        }


        // Somente movimento vertical é parado
        velv = 0;
        move_rem_y = 0;

        break;
    }
}


// ============================================================
// SENSORES FINAIS
// ============================================================

on_ground = player_on_ground(x, y);

wall_left  = player_wall_left(x, y);
wall_right = player_wall_right(x, y);

hit_ceiling = player_hit_ceiling(x, y);


// ============================================================
// GARANTE QUE NÃO FIQUE DESCENDO SOBRE O CHÃO
// ============================================================

if (on_ground && velv > 0)
{
    velv = 0;
}


// ============================================================
// WALL JUMP LOCK
// ============================================================

if (wall_jump_lock <= 0)
{
    wall_jump_lock = 0;
}

/// ============================================================
/// WALL SYSTEM
/// ============================================================


// ============================================================
// RESET
// ============================================================

wall_sliding = false;
wall_grabbing = false;


// ============================================================
// PLAYER ESTÁ NO AR?
// ============================================================

if (!on_ground)
{
    // Existe parede ao lado
    if (wall_left || wall_right)
    {
        // ====================================================
        // WALL SLIDE
        // ====================================================

        if (velv > 0)
        {
            wall_sliding = true;

            // Limita velocidade de queda
            velv = min(velv, 1.5);
        }


        // ====================================================
        // WALL JUMP
        // ====================================================

        if (keyboard_check_pressed(vk_space))
        {
            // Parede esquerda
            if (wall_left)
            {
                velh = 5;
            }

            // Parede direita
            else if (wall_right)
            {
                velh = -5;
            }


            // Impulso vertical
            velv = -7;


            // Remove resto acumulado
            move_rem_x = 0;
            move_rem_y = 0;


            // Evita reencostar imediatamente
            wall_jump_lock = 6;


            // Estado visual/opcional
            wall_sliding = false;
        }
    }
}