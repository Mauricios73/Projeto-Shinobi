

depth = -2000; // Ajuste para ficar logo acima da água, mas atrás do player se quiser

// Cria o sistema de partículas no mundo
fog_sys = part_system_create();
part_system_depth(fog_sys, depth);

// Cria o tipo de partícula (A Nuvem)
fog_type = part_type_create();
part_type_shape(fog_type, pt_shape_cloud); // Forma de nuvem nativa do GM
part_type_size(fog_type, 1.5, 3.0, 0, 0.02); // Nuvens de tamanhos variados e leve pulso
part_type_scale(fog_type, 2.0, 0.5); // Achata a nuvem horizontalmente para parecer névoa rasteira

// Transição de Alpha: Nasce invisível, fica suave, some suavemente
part_type_alpha3(fog_type, 0, 0.88, 0); 
part_type_color1(fog_type, c_white);

// Movimento: Anda devagar para o lado (drift)
part_type_speed(fog_type, 0.1, 0.3, 0, 0);
part_type_direction(fog_type, 0, 10, 0, 2); // Vai da esquerda para a direita levemente ondulando
part_type_life(fog_type, 400, 700); // Longa duração para cruzar a tela devagar

// Cria o Emissor
fog_emit = part_emitter_create(fog_sys);

// Estado de dissipação (para sumir suavemente quando o clima mudar)
is_fading_out = false;