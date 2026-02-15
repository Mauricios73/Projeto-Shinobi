/// obj_menu - STEP (REESCRITO)
// Requer: create_menu_page com ds_grid_create(6, ...)
// Requer: slider/shift/toggle chamarem script_execute e salvarem via scr_save_settings()
// Requer: change_volume(value, type) usando o type salvo na coluna 5 (extra)

// Só trava pelo pause quando este menu estiver em modo PAUSE.
// No menu principal (main) ele deve rodar normal.
if (variable_global_exists("menu_mode")) {
    if (global.menu_mode == "pause" && !global.pause) exit;
} else {
    // fallback antigo
    if (!global.pause) exit;
}

// Inputs
var input_up_p     = keyboard_check_pressed(global.key_up);
var input_down_p   = keyboard_check_pressed(global.key_down);
var input_enter_p  = keyboard_check_pressed(global.key_enter);
var input_revert_p = keyboard_check_pressed(global.key_revert);

var ds_ = menu_pages[page];
var ds_height = ds_grid_height(ds_);

// =========================
// MODO INPUTTING (editando valor)
// =========================
if (inputting) {

    var opt = menu_option[page];
    var etype = ds_[# 1, opt];

    switch (etype) {

        case menu_element_type.shift:
        {
            var hinput = keyboard_check_pressed(global.key_right) - keyboard_check_pressed(global.key_left);
            if (hinput != 0) {
                ds_[# 3, opt] += hinput;
                ds_[# 3, opt] = clamp(ds_[# 3, opt], 0, array_length_1d(ds_[# 4, opt]) - 1);

                // aplica + salva imediatamente
                var val = ds_[# 3, opt];
                var fn  = ds_[# 2, opt];
                var extra = ds_[# 5, opt];

                if (is_undefined(extra)) script_execute(fn, val);
                else                     script_execute(fn, val, extra);

                scr_save_settings();
            }
        }
        break;

        case menu_element_type.slider:
        {
            var hinput = keyboard_check(global.key_right) - keyboard_check(global.key_left);
            if (hinput != 0) {
                ds_[# 3, opt] += hinput * 0.01;
                ds_[# 3, opt] = clamp(ds_[# 3, opt], 0, 1);

                // aplica + salva imediatamente
                var val = ds_[# 3, opt];
                var fn  = ds_[# 2, opt];
                var extra = ds_[# 5, opt];

                if (is_undefined(extra)) script_execute(fn, val);
                else                     script_execute(fn, val, extra);

                scr_save_settings();
            }
        }
        break;

        case menu_element_type.toggle:
        {
            var hinput = keyboard_check_pressed(global.key_right) - keyboard_check_pressed(global.key_left);
            if (hinput != 0) {
                ds_[# 3, opt] += hinput;
                ds_[# 3, opt] = clamp(ds_[# 3, opt], 0, 1);

                // aplica + salva imediatamente
                var val = ds_[# 3, opt];
                var fn  = ds_[# 2, opt];
                var extra = ds_[# 5, opt];

                if (is_undefined(extra)) script_execute(fn, val);
                else                     script_execute(fn, val, extra);

                scr_save_settings();
            }
        }
        break;

        case menu_element_type.input:
        {
            // Cancelar captura com X (global.key_revert)
            if (input_revert_p) {
                inputting = false;
                break;
            }

            // Captura tecla
            var kk = keyboard_lastkey;

            // evita capturar ENTER (pois é o botão de confirmar)
            if (kk != 0 && kk != vk_enter) {

                // atualiza no grid
                if (kk != ds_[# 3, opt]) {
                    ds_[# 3, opt] = kk;

                    // atualiza no global (nome do campo está em ds_[#2,opt], ex: "key_up")
                    variable_global_set(ds_[# 2, opt], kk);

                    // salva
                    scr_save_settings();
                }

                // sai do modo captura depois de setar
                inputting = false;
            }
        }
        break;
    }

}
// =========================
// MODO NAVEGAÇÃO (escolhendo item)
// =========================
else {

    var ochange = input_down_p - input_up_p;

    if (ochange != 0) {
        menu_option[page] += ochange;

        if (menu_option[page] > ds_height - 1) menu_option[page] = 0;
        if (menu_option[page] < 0)             menu_option[page] = ds_height - 1;
    }
}

// =========================
// ENTER (executar / entrar em edição)
// =========================
if (input_enter_p) {

    var opt = menu_option[page];
    var etype = ds_[# 1, opt];

    switch (etype) {

        case menu_element_type.script_runner:
        {
            script_execute(ds_[# 2, opt]);
        }
        break;

        case menu_element_type.page_transfer:
        {
            page = ds_[# 2, opt];
        }
        break;

        case menu_element_type.shift:
        case menu_element_type.slider:
        case menu_element_type.toggle:
        case menu_element_type.input:
        {
            // alterna modo edição/captura
            inputting = !inputting;

            // (Opcional) se você quiser aplicar e salvar ao SAIR do modo edição:
            // if (!inputting) { ... }
        }
        break;
    }
}
