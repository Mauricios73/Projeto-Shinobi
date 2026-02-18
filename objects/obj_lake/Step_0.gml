// Movimento da espuma
for (var i = 0; i < foam_n; i++)
{
    foam_x[i] += foam_spd[i];
    foam_y[i] += 0.02;

    if (foam_x[i] > w) foam_x[i] -= w;
    if (foam_y[i] > h) foam_y[i] -= h;
}
