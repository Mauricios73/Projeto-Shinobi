if (game_over)
{
	var x1 = camera_get_view_x(view_camera[0]);
	var w = camera_get_view_width(view_camera[0]);
	var x2 = x1 + w;
	var meio_w = x1 + w/2;	
	var y1 = camera_get_view_y(view_camera[0]);
	var h = camera_get_view_height(view_camera[0]);
	var y2 = y1 + h;
	var meio_h = y1 + h/2;
	
	var qtd = h * .15;
	
	valor = lerp(valor, 1, .03);
	
	draw_set_color(c_black);
	//escurecendo a tela
	draw_set_alpha(valor - .3);
	draw_rectangle(x1, y1, x2, y2, false);
	
	//retangulo de cima
	draw_set_alpha(1);
	draw_rectangle(x1, y1, x2, y1 + qtd * valor, false);
	
	//retangulo de baixo
	draw_rectangle(x1, y2, x2, y2 - qtd * valor, false);
	
	draw_set_alpha(1);
	draw_set_color(-1);
	
	//delay game-over
	if (valor > .85)
	{
		contador = lerp(contador, 1, .01);
		//escrevendo game-over
		draw_set_alpha(contador);
		draw_set_font(fnt_asian_ninja);
		draw_set_valign(1);
		draw_set_halign(1);
		//sombra
		draw_set_colour(c_red);
		draw_text(meio_w + 1, meio_h + 1, "G a m e - O v e r");
		//texto
		draw_set_colour(c_white);
		draw_text(meio_w, meio_h, "G a m e - O v e r");
		draw_set_font(-1);
		
		draw_text(meio_w, meio_h + 50, "Press ENTER to restart");
		
		draw_set_valign(-1);
		draw_set_halign(-1);
		
		draw_set_alpha(-1);
	}
}
else
{ 
	valor = 0;
}