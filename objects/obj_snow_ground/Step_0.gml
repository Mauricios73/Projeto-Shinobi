if (!variable_global_exists("snow_amount")) exit;
if (global.snow_amount <= 0) exit;

// Faz a neve flutuante deslizar devagarzinho para a direita, de forma independente
for (var i = 0; i < num_patches; i++)
{
    patch_world_x[i] += patch_spd[i];
}