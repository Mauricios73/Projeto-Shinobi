depth = -10000;
// ===== CONFIG =====
fog_enabled = true;

// cores
fog_col_top    = make_color_rgb(185, 195, 205);
fog_col_bottom = make_color_rgb(120, 130, 145);

// forças (ajuste fino)
fog_alpha_base = 0.05;
fog_alpha_grad = 0.12;

// blobs
fog_blob_n = 16;

// movimento
wind_speed = 0.00025;
wind_amp   = 0.40;

// ---- low-res fog surface (blur) ----
fog_div = 7;      // 6..8 (maior = mais suave)
surf_fog = -1;

// faixa (onde aparece a fog)
fog_band_h      = 260; // altura principal perto do lago
fog_band_offset = 90;  // sobe acima da linha d'água (maior = mais pra cima)
fog_floor_h     = 120; // leve no chão
fog_floor_offset= 170;

// guarda gui size
guiW = 0;
guiH = 0;

// init arrays
fog_blob_x   = array_create(fog_blob_n);
fog_blob_y   = array_create(fog_blob_n);
fog_blob_r   = array_create(fog_blob_n);
fog_blob_spd = array_create(fog_blob_n);
fog_blob_a   = array_create(fog_blob_n);
