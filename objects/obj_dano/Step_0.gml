var outro;
var outro_lista = ds_list_create();
var quantidade = instance_place_list(x, y, obj_entidade, outro_lista, 0);

// adicionando todo mundo a lista
for (var i = 0; i < quantidade; i ++)
{
	//checando o atual
	var atual = outro_lista[| i];
	
	if (atual.invencivel){
		continue;
	}
	
	//show_message(object_get_name(atual.object_index));
	//checando a colisão com o filho do meu pai
	if (object_get_parent(atual.object_index) != object_get_parent(pai.object_index))
	{
		//show_message("posso dar dano");
		//isso so vai rodar se eu puder dar dano 
		
		//checar se eu realmente posso dar dano
		
		//checar se o atual ja esta na lista
		var pos = ds_list_find_index(aplicar_dano, atual);
		if (pos == -1)
		{
			// o atual ainda não está na lista de dano
			//adicionando o atual a lista de dano
			ds_list_add(aplicar_dano, atual);
		}
	}
}

//aplicando o dano
var tam = ds_list_size(aplicar_dano);
for (var i = 0; i < tam; i++)
{
	outro = aplicar_dano[| i]. id;
	if (outro.vida_atual > 0)
	{
		if (outro.delay <= 0){
			outro.estado = "hit";
			outro.image_index = 0;
		}
		outro.vida_atual -= dano;
		
		//checando o inimigo para screenshake
		if (object_get_parent(outro.object_index) == obj_entidade_inimigo){
			screenshake(1.5);
			
			if (outro.vida_atual <= 0)
			{
				outro.estado = "dead";
			}
		}
	}
}

//apagando as listas
ds_list_destroy(aplicar_dano);
ds_list_destroy(outro_lista);

if (morrer){
	instance_destroy();
}
else
{

	x = pai.x + offset_x;
	y = pai.y + offset_y;
	
	if (image_index >= image_number -1 || morrer)
	{
    instance_destroy();
	}
}
