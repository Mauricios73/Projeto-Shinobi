//texto = "";
//cor = c_white;
//vel_y = -2;
//alpha = 1;

texto = "0";
cor = c_white;

life = 45; // frames de vida
alpha = 1;

x_offset = irandom_range(-10, 10);
y_offset = irandom_range(-8, 6);

vx = random_range(-0.6, 0.6);   // espalha pro lado
vy = random_range(-2.0, -1.2);  // sobe

grav = 0.06; // leve “queda” depois

// tamanho (se quiser variar)
scale = random_range(0.95, 1.1);
