gpu_set_blendmode(bm_normal);
draw_set_color(c_white);

for (var i = 0; i < snow_n; i++)
{
    var a = sa[i] * (0.70 + 0.30 * abs(sin((current_time + ph[i]) * 0.004)));
    draw_set_alpha(a);

    var x1 = sx[i];
    var y1 = sy[i];

    var w1, h1;
    if (ss[i] == 1) { w1 = 1; h1 = 1; }
    else if (ss[i] == 2) { w1 = 2; h1 = 1; }
    else { w1 = 3; h1 = 2; }

    draw_rectangle(x1, y1, x1 + w1, y1 + h1, false);
}

draw_set_alpha(1);
