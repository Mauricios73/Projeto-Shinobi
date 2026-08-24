// obj_entidade_inimigo - Begin Step
event_inherited();

if (place_meeting(x + mid_velh, y, obj_block))
{
    mid_velh *= -1;
}

if (object_index != obj_dummy)
{
    if (estado == "parado") enemy_set_state("idle");
    if (estado == "movendo") enemy_set_state("patrulha");
    if (estado == "hit") enemy_set_state("dano");
    if (estado == "dead") enemy_set_state("morte");
}

if (estado != "ataque")
{
    if (variable_instance_exists(id, "dano") && dano != noone)
    {
        if (instance_exists(dano))
        {
            instance_destroy(dano);
        }

        dano = noone;
        posso = true;
    }
}

if (estado == "dano") pstate = PST_HIT;
if (estado == "morte") pstate = PST_DEAD;
if (estado == "idle") pstate = PST_IDLE;
