function scr_funcoes(){

}

//enumerator para definir as possiveis ações
enum menu_acoes
{
	roda_metodo,
	carrega_menu
}

enum menus_lista
{
	principal,
	opcoes 
}

//screenshake
///@function screenshake(valor_da_tremida)
///@arg força_da_tremida
///@arg [dir_mode]
///@arg [direcao]
function screenshake(_treme, _dir_mode, _direcao){
	var shake = instance_create_layer(0, 0, "instances", obj_screenshake);
	shake.shake = _treme;
	shake.dir_mode = _dir_mode;
	shake.dir = _direcao;
}

//define align
///@function define_align(vertical, horizontal)
function define_align(_ver, _hor)
{
	draw_set_halign(_hor);
	draw_set_valign(_ver);
}