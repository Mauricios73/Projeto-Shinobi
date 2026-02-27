/// obj_lake_v3 - Create
depth = 1000;

// cobre a room toda
x = 0;
lake_w = room_width;
lake_h = 320; // ajuste: 260..360

// linha d’água = y do objeto (vamos travar no chão no Step)
reflect_alpha = 0.55;

// ondas Kingdom
wave_amp   = 2.0;
wave_freq  = 0.055;
wave_speed = 0.0016;
slice_h    = 1;

calm_zone_px  = 5;
build_zone_px = 70;
depth_fade_strength = 0.60;

// shimmer (muito sutil)
shimmer_amp   = 0.45;
shimmer_scale = 18;

// dashes (pontos/linhas na água)
spark_n = 520;
spark_x = array_create(spark_n);
spark_y = array_create(spark_n);
spark_len = array_create(spark_n);
spark_spd = array_create(spark_n);
spark_a = array_create(spark_n);
spark_ph = array_create(spark_n);

spark_seed = irandom(999999);

for (var i = 0; i < spark_n; i++)
{
    spark_x[i]   = random(lake_w);
    // mais concentrado na parte de cima, mas ainda existe no fundo
    var r = random(1);
    spark_y[i]   = power(r, 1.35) * lake_h;

    spark_len[i] = irandom_range(2, 10);

    // metade vai pra direita, metade pra esquerda (bem lento)
    spark_spd[i] = choose(-1, 1) * random_range(6, 18);

    // alpha cai com profundidade
    var d = spark_y[i] / lake_h;
    spark_a[i] = lerp(0.22, 0.06, d);

    spark_ph[i] = irandom(999999);
}

// surface do reflexo (somente visível)
surf_reflect = -1;
surf_w = 0;
surf_h = 0;

// ===== trava no chão =====
auto_lock_to_ground = true;
waterline_offset_px = 22; // ajuste fino: 6..16
probe_extra_up = 200;
probe_extra_down = 600;

// ===== RIPPLES (chuva na água) =====
ripple_max   = 90;
ripple_x     = array_create(ripple_max);
ripple_t     = array_create(ripple_max);
ripple_str   = array_create(ripple_max);

// NOVO: profundidade e “tipo”
ripple_yoff  = array_create(ripple_max); // 0..lake_h
ripple_deep  = array_create(ripple_max); // true/false

ripple_life  = 0.35;  // segundos
ripple_size  = 14;    // px (tamanho final do oval)
ripple_alpha = 0.35;  // intensidade

ripple_head  = 0;

for (var i = 0; i < ripple_max; i++)
{
    ripple_t[i] = -1; // inativo
}

// helper: cria ripple no mundo
add_ripple = function(_wx, _strength, _yoff, _deep)
{
    if (is_undefined(_yoff)) _yoff = 2;
    if (is_undefined(_deep)) _deep = false;

    var i = ripple_head;
    ripple_head = (ripple_head + 1) mod ripple_max;

    ripple_x[i]   = _wx;
    ripple_t[i]   = 0;
    ripple_str[i] = _strength;

    ripple_yoff[i] = _yoff;   // ← agora cada ripple pode nascer “no meio”
    ripple_deep[i] = _deep;
};