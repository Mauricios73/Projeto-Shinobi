var _cam_x = camera_get_view_x(view_camera[0]);


layer_x("Backgrounds_12", _cam_x * 0.0);
layer_x("Backgrounds_11", _cam_x * 0.0); 
layer_x("Backgrounds_10", _cam_x * 0.1); 
layer_x("Backgrounds_9", _cam_x * 0.4); 
layer_x("Backgrounds_8", _cam_x * 0.5); 
layer_x("Backgrounds_7", _cam_x * 0.5); 
layer_x("Backgrounds_6", _cam_x * 0.6); 
layer_x("Backgrounds_5", _cam_x * 0.7); 
layer_x("Backgrounds_4", _cam_x * 0.7); 
layer_x("Backgrounds_3", _cam_x * 0.8); 
layer_x("Backgrounds_2", _cam_x * 0.9); 
layer_x("Backgrounds_1", _cam_x * 0.9); 
 

// O cálculo é: (Posição da Câmera * Fator de Parallax)
// Quanto maior o número (ex: 0.9), mais o fundo "segue" a câmera, parecendo mais longe.