function scr_fire_breath_profile(_lv)
{
    _lv = max(1, _lv);

    var tier, step;

    // ✅ Tier 1 = lv 1..4
    // ✅ Tier 2 = lv 5..9
    // ✅ Tier 3 = lv 10..14
    if (_lv <= 4)
    {
        tier = 1;
        step = _lv - 1;           // 0..3
    }
    else
    {
        tier = 2 + floor((_lv - 5) / 5); // lv5..9 => 2, lv10..14 => 3...
        step = (_lv - 5) mod 5;          // lv5 =>0, lv9=>4, lv10=>0
    }

    // ✅ escala cresce dentro do tier
    // tier1: 1.00,1.10,1.20,1.30
    // tier2+: 1.00..1.40
    var scale = 1.0 + (step * 0.10);

    // ✅ sprites por tier (troque pelos seus nomes reais)
    var spr;
    switch (tier)
    {
        case 1: spr = spr_fire_breath; break;
        case 2: spr = spr_fire_breath_2; break; // lv 5
        case 3: spr = spr_fire_breath_3; break; // lv 10
        default: spr = spr_fire_breath_3; break;
    }

    return { tier: tier, step: step, scale: scale, sprite: spr };
}
