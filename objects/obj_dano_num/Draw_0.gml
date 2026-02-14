//draw_set_alpha(alpha);
//draw_set_color(cor);
//draw_text(x, y, texto);
//draw_set_alpha(1);

draw_set_alpha(alpha);
draw_set_color(cor);

// sombra (melhora MUITO leitura)
draw_text_transformed(x + 1, y + 1, texto, scale, scale, 0);

// texto
draw_set_color(c_white); // ou mantém cor e usa sombra escura, sua escolha
draw_text_transformed(x, y, texto, scale, scale, 0);

draw_set_alpha(1);
