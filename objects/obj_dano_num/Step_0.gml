//y += vel_y;
//alpha -= 0.02;
//if (alpha <= 0) instance_destroy();

x += vx;
y += vy;
vy += grav;

life--;
if (life < 15) alpha = life / 15; // fade no final

if (life <= 0) instance_destroy();
