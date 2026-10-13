/// ============================================================
/// OBJ_ENTIDADE_PLAYER
/// STEP
/// MOVIMENTO + COLISÃO + WALL SYSTEM
/// ============================================================


// ============================================================
// RESET DOS CONTATOS
// ============================================================

on_ground   = false;
hit_ceiling = false;

wall_left  = false;
wall_right = false;


// ============================================================
// WALL JUMP LOCK
// ============================================================

if (wall_jump_lock > 0)
{
    wall_jump_lock--;
}


// ============================================================
// MOVIMENTO HORIZONTAL
// ============================================================

move_rem_x += velh;


// Quantidade inteira de pixels
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
        // ----------------------------------------------------
        // Parede esquerda
        // ----------------------------------------------------

        if (_dir_x < 0)
        {
            wall_left = true;
        }

        // ----------------------------------------------------
        // Parede direita
        // ----------------------------------------------------

        else
        {
            wall_right = true;
        }


        // ----------------------------------------------------
        // IMPORTANTE
        // ----------------------------------------------------
        // A colisão horizontal NÃO interfere na velocidade
        // vertical.
        //
        // Isso permite:
        // - queda junto da parede
        // - Wall Slide
        // - Wall Jump
        // - Wall Climb
        // ----------------------------------------------------

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
        // ----------------------------------------------------
        // Estamos descendo
        // ----------------------------------------------------

        if (_dir_y > 0)
        {
            on_ground = true;
        }

        // ----------------------------------------------------
        // Estamos subindo
        // ----------------------------------------------------

        else
        {
            hit_ceiling = true;
        }


        // Somente o movimento vertical é interrompido.
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


/// ============================================================
/// WALL SYSTEM
/// ============================================================


// ============================================================
// RESET
// ============================================================

wall_sliding  = false;
wall_grabbing = false;


// ============================================================
// PLAYER ESTÁ NO AR?
// ============================================================

if (!on_ground)
{
    // ========================================================
    // EXISTE UMA PAREDE AO LADO?
    // ========================================================

    if (wall_left || wall_right)
    {
        // ====================================================
        // WALL SLIDE
        // ====================================================

        if (velv > 0)
        {
            wall_sliding = true;

            // Limita a velocidade de queda.
            velv = min(velv, wall_slide_speed);
        }


        // ====================================================
        // WALL JUMP
        // ====================================================
        //
        // Só pode executar se:
        //
        // 1. Está no ar
        // 2. Está encostado em uma parede
        // 3. Não está no lock de Wall Jump
        // 4. O botão de pulo foi pressionado
        //
        // ====================================================

        if (
            keyboard_check_pressed(vk_space)
            &&
            wall_jump_lock <= 0
        )
        {
            var _wall_jump_dir = 0;


            // ------------------------------------------------
            // Parede esquerda
            // ------------------------------------------------
            // Player deve ser lançado para a direita.
            // ------------------------------------------------

            if (wall_left)
            {
                _wall_jump_dir = 1;
            }


            // ------------------------------------------------
            // Parede direita
            // ------------------------------------------------
            // Player deve ser lançado para a esquerda.
            // ------------------------------------------------

            else if (wall_right)
            {
                _wall_jump_dir = -1;
            }


            // =================================================
            // EXISTE UMA DIREÇÃO VÁLIDA?
            // =================================================

            if (_wall_jump_dir != 0)
            {
                // ---------------------------------------------
                // AFASTA O PLAYER DA PAREDE
                // ---------------------------------------------
                //
                // Isso é fundamental.
                //
                // Sem este passo:
                //
                //     parede
                //       │
                //       │ PLAYER →→
                //
                // a próxima resolução de colisão pode anular
                // imediatamente o impulso horizontal.
                //
                // ---------------------------------------------

                repeat (wall_jump_push)
                {
                    if (!collision_player(
                        x + _wall_jump_dir,
                        y
                    ))
                    {
                        x += _wall_jump_dir;
                    }
                    else
                    {
                        break;
                    }
                }


                // ---------------------------------------------
                // REMOVE RESTOS SUBPIXEL
                // ---------------------------------------------

                move_rem_x = 0;
                move_rem_y = 0;


                // ---------------------------------------------
                // IMPULSO HORIZONTAL
                // ---------------------------------------------

                velh = _wall_jump_dir * wall_jump_h;


                // ---------------------------------------------
                // IMPULSO VERTICAL
                // ---------------------------------------------

                velv = -wall_jump_v;


                // ---------------------------------------------
                // ATIVA LOCK
                // ---------------------------------------------

                wall_jump_lock = 6;


                // ---------------------------------------------
                // SAI DO WALL SLIDE
                // ---------------------------------------------

                wall_sliding = false;
                wall_grabbing = false;


                // ---------------------------------------------
                // ATUALIZA CONTATOS
                // ---------------------------------------------

                wall_left  = false;
                wall_right = false;
            }
        }
    }
}


// ============================================================
// ESTADO FINAL DO WALL SLIDE
// ============================================================
//
// Se acabou de executar Wall Jump, não queremos que o sistema
// imediatamente volte para Wall Slide no mesmo frame.
//

if (wall_jump_lock > 0)
{
    wall_sliding = false;
}