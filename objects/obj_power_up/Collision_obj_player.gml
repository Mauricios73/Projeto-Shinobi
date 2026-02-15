var sc = instance_find(obj_skill_controller, 0);
if (sc != noone)
{
    // exemplo: indice 0 = chidori
    if (indice == 0) sc.unlock_skill("chidori");
	if (indice == 0) sc.unlock_skill("fire_breath");
    // se tiver outros no futuro, adiciona aqui
}

instance_destroy();
