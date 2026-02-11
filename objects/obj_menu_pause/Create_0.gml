
//seleção do menu
sel = 0;
marg_val = 0;
marg_total = 32; 
pag = 0;

#region METODOS

desenha_menu = function(_menu)
{
	//definindo fonte
	draw_set_font(fnt_asian);

	//alinhando o texto
	define_align(0, 0);  

	//desenhando o menu
	//pegando o tamanho do menu 
	var _qtd = array_length(_menu);

	//pegando a altura de tela
	var _alt = display_get_gui_height();

	//definindo o espaço entre linhas
	var _espaco_y = string_height("I") + 16;
	var _alt_menu = _espaco_y * _qtd;


	//desenhando as opções
	for (var i = 0; i < _qtd; i++)
	{
		//cor do texto
		var _cor = c_white, _marg_x = 0;
	
		//desenhando o item do menu
		var _texto = _menu[i][0];
		if (menus_sel[pag] == i)
		{
			_cor = c_yellow;
			_marg_x = marg_val;
		}
	  
		draw_text_color(20 + _marg_x, (_alt /2) -_alt_menu /2 + (i * _espaco_y), _texto, _cor, _cor, _cor, _cor, 1);
	}
	 //reset do draw set
	draw_set_font(-1);
	define_align(-1, -1);
}

controla_menu = function(_menu)
{
	var _up, _down, _enter, _back;
	//var _sel = menus_sel[pag];

	_up		= keyboard_check_pressed(ord("W"));
	_down	= keyboard_check_pressed(ord("S"));
	_enter	= keyboard_check_released(vk_enter);
	_back	= keyboard_check_released(vk_escape);

	if (_up or _down) 
	{
		
		menus_sel[pag] += _down - _up;
		//limitando vetor de seleção
		var _tam = array_length(_menu) - 1;
		menus_sel[pag] = clamp(menus_sel[pag], 0, _tam);
		marg_val = 0;
	}
	marg_val = lerp(marg_val, marg_total, .2);
	
	if (_enter)
	{
		switch(_menu[menus_sel[pag]][1])
		{
			case 0: _menu[menus_sel[pag]][2](); break;
			case 1: pag = _menu[menus_sel[pag]][2]; break;
		}
	}
} 

inicia_jogo = function()
{
	room_goto(Room1);
}

fecha_jogo = function()
{
	game_end();
}

#endregion

//criação do menu
menu_principal = [
		 			["Iniciar", menu_acoes.roda_metodo, inicia_jogo],
					["Options", menu_acoes.carrega_menu, menus_lista.opcoes],
					["Sair ", menu_acoes.roda_metodo, fecha_jogo]
				];
				
menu_opcoes =	[
					["Audio", menu_acoes.roda_metodo, inicia_jogo],
					["Video", menu_acoes.roda_metodo, inicia_jogo],
					["Controles", menu_acoes.roda_metodo, inicia_jogo],
					["Voltar", menu_acoes.carrega_menu, menus_lista.principal],
				];

//salvando menus 
menus = [menu_principal, menu_opcoes];
menus_sel = array_create(array_length(menus), 0)