var sc = instance_find(obj_skill_controller, 0);
if (sc != noone)
{
    if (indice == 0) sc.unlock_skill("chidori");
    else if (indice == 1) sc.unlock_skill("fire_breath");
}
instance_destroy();