/// obj_menu - Draw
/// Menu principal atmosferico + paginas de settings.

if (variable_global_exists("game_over") && global.game_over)
    exit;

if (variable_global_exists("menu_mode"))
{
    if (global.menu_mode == "pause" && !global.pause)
        exit;
}
else
{
    if (!global.pause)
        exit;
}

var gwidth  = global.view_width;
var gheight = global.view_height;

var is_pause_menu = variable_global_exists("menu_mode") && global.menu_mode == "pause";

// ============================================================
// PAUSE MENU - preserva o sistema atual
// ============================================================
if (is_pause_menu)
{
    var ds_pause = menu_pages[page];
    var ds_pause_height = ds_grid_height(ds_pause);
    var pause_gw = display_get_gui_width();
    var pause_gh = display_get_gui_height();

    var panel_w = min(620, pause_gw * 0.72);
    var panel_h = min(330, pause_gh * 0.52);
    var px = pause_gw * 0.5 - panel_w * 0.5;
    var py = pause_gh * 0.5 - panel_h * 0.5;

    if (variable_global_exists("pause_surface") && surface_exists(global.pause_surface))
    {
        draw_set_alpha(1);
        draw_surface_stretched(global.pause_surface, 0, 0, pause_gw, pause_gh);
    }

    draw_set_alpha(0.54);
    draw_set_color(c_black);
    draw_rectangle(0, 0, pause_gw, pause_gh, false);

    draw_set_alpha(0.84);
    draw_set_color(make_color_rgb(10, 8, 8));
    draw_rectangle(px, py, px + panel_w, py + panel_h, false);

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(150, 20, 20));
    draw_rectangle(px, py, px + panel_w, py + 4, false);
    draw_rectangle(px, py + panel_h - 4, px + panel_w, py + panel_h, false);
    draw_rectangle(px, py, px + 4, py + panel_h, false);
    draw_rectangle(px + panel_w - 4, py, px + panel_w, py + panel_h, false);

    var font_menu_pause = asset_get_index("fnt_asian_ninja");

    if (font_menu_pause != -1)
        draw_set_font(font_menu_pause);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);
    draw_text(pause_gw * 0.5 + 2, py + 72, "PAUSE");

    draw_set_color(make_color_rgb(185, 22, 22));
    draw_text(pause_gw * 0.5, py + 70, "PAUSE");

    var y_gap_pause = 44;
    var start_y_pause = py + 158;

    for (var ip = 0; ip < ds_pause_height; ip++)
    {
        var txt = ds_pause[# 0, ip];
        var col = (ip == menu_option[page]) ? c_yellow : c_white;
        var xoff = (ip == menu_option[page]) ? -8 : 0;

        draw_set_color(c_black);
        draw_text(pause_gw * 0.5 + xoff + 2, start_y_pause + ip * y_gap_pause + 2, txt);

        draw_set_color(col);
        draw_text(pause_gw * 0.5 + xoff, start_y_pause + ip * y_gap_pause, txt);
    }

    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);

    exit;
}

// ============================================================
// MENU PRINCIPAL
// ============================================================
if (page == menu_page.main)
{
    var alpha = clamp(menu_intro_alpha, 0, 1);
    var cx = gwidth * 0.5;

    // Escurecimento cinematografico leve.
    draw_set_color(c_black);

    draw_set_alpha(0.08 * alpha);
    draw_rectangle(0, 0, gwidth, gheight, false);

    // Vignette simples nas bordas.
    for (var v = 0; v < 5; v++)
    {
        var va = (0.018 * (5 - v)) * alpha;

        draw_set_alpha(va);
        draw_rectangle(0, v * 22, gwidth, (v + 1) * 22, false);
        draw_rectangle(0, gheight - ((v + 1) * 22), gwidth, gheight - (v * 22), false);
    }

    var font_menu = asset_get_index("fnt_asian_ninja");

    if (font_menu != -1)
        draw_set_font(font_menu);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // --------------------------------------------------------
    // TITULO
    // --------------------------------------------------------
    var title_y = gheight * 0.20;
    var subtitle_y = title_y + 58;

    var title_float = sin(menu_time * 0.035) * 2.0;

    draw_set_alpha(alpha);

    draw_set_color(menu_shadow_color);
    draw_text_transformed(
        cx + 3,
        title_y + title_float + 3,
        menu_title,
        menu_title_scale,
        menu_title_scale,
        0
    );

    draw_set_color(make_color_rgb(238, 232, 185));
    draw_text_transformed(
        cx,
        title_y + title_float,
        menu_title,
        menu_title_scale,
        menu_title_scale,
        0
    );

    draw_set_color(make_color_rgb(238, 232, 185));
    draw_text_transformed(
        cx,
        subtitle_y,
        menu_subtitle,
        menu_subtitle_scale,
        menu_subtitle_scale,
        0
    );

    // Linha decorativa.
    draw_set_alpha(alpha * 0.45);
    draw_set_color(make_color_rgb(190, 185, 150));
    draw_line(cx - 110, subtitle_y + 27, cx + 110, subtitle_y + 27);

    // --------------------------------------------------------
    // OPCOES
    // --------------------------------------------------------
    var ds_main = menu_pages[page];
    var main_count = ds_grid_height(ds_main);
    var start_y = gheight * 0.58;

    for (var i = 0; i < main_count; i++)
    {
        var selected = (i == menu_option[page]);

        var yy = start_y + i * menu_main_gap;
        var xx = cx;

        if (selected)
            xx -= 8 + menu_selection_bump * 5;

        var col = selected ? menu_selected_color : menu_normal_color;

        // sombra
        draw_set_alpha(alpha * 0.85);
        draw_set_color(menu_shadow_color);

        draw_text_transformed(
            xx + 3,
            yy + 3,
            ds_main[# 0, i],
            menu_option_scale,
            menu_option_scale,
            0
        );

        draw_set_color(col);

        draw_text_transformed(
            xx,
            yy,
            ds_main[# 0, i],
            menu_option_scale,
            menu_option_scale,
            0
        );

        if (selected)
        {
            var pulse = 1 + sin(menu_time * 0.08) * 0.035;

            draw_set_alpha(alpha * 0.90);

            draw_text_transformed(
                xx - 105,
                yy,
                ">",
                0.9 * pulse,
                0.9 * pulse,
                0
            );

            draw_set_alpha(alpha * 0.18);
            draw_line(
                xx - 72,
                yy + 18,
                xx + 72,
                yy + 18
            );
        }
    }

    // --------------------------------------------------------
    // CONTROLES
    // --------------------------------------------------------
    if (menu_show_help)
    {
        draw_set_alpha(alpha * 2.35);
        draw_set_color(make_color_rgb(175, 175, 165));

        draw_text_transformed(
            cx,
            gheight - 42,
            "W / S  •  NAVIGAR        ENTER  •  SELECIONAR        X  •  VOLTAR",
            0.55,
            0.55,
            0
        );
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    exit;
}

// ============================================================
// SETTINGS / SUBPAGINAS
// ============================================================
var ds_ = menu_pages[page];
var ds_height = ds_grid_height(ds_);

draw_set_alpha(1);
draw_set_valign(fa_middle);
draw_set_halign(fa_right);

var y_buffer = 36;
var x_buffer = 20;

var start_y = (gheight / 2) - (((ds_height - 1) / 2) * y_buffer);
var start_x = gwidth / 2;

var ltx = start_x - x_buffer;
var lty;
var c;
var xo;

for (var yy_i = 0; yy_i < ds_height; yy_i++)
{
    lty = start_y + (yy_i * y_buffer);
    c = c_white;
    xo = 0;

    if (yy_i == menu_option[page])
    {
        c = c_yellow;
        xo = -x_buffer / 2;
    }

    draw_set_color(c_black);
    draw_text(ltx + xo + 2, lty + 2, ds_[# 0, yy_i]);

    draw_set_color(c);
    draw_text(ltx + xo, lty, ds_[# 0, yy_i]);
}

// divisor
draw_set_color(make_color_rgb(150, 145, 120));
draw_line(start_x, start_y - y_buffer, start_x, lty + y_buffer);

// values
draw_set_halign(fa_left);

var rtx = start_x + x_buffer;
var rty;

for (var yy_v = 0; yy_v < ds_height; yy_v++)
{
    rty = start_y + (yy_v * y_buffer);

    switch(ds_[# 1, yy_v])
    {
        case menu_element_type.shift:
        {
            var current_val_shift = ds_[# 3, yy_v];
            var words_shift = ds_[# 4, yy_v];

            var left_shift = (current_val_shift == 0) ? "" : "<< ";
            var right_shift = (current_val_shift == array_length_1d(words_shift) - 1) ? "" : " >>";

            var col_shift = (inputting && yy_v == menu_option[page]) ? c_yellow : c_white;

            draw_set_color(col_shift);

            draw_text(
                rtx,
                rty,
                left_shift + words_shift[current_val_shift] + right_shift
            );
        }
        break;

        case menu_element_type.slider:
        {
            var len_slider = 64;
            var current_val_slider = ds_[# 3, yy_v];

            var col_slider = (inputting && yy_v == menu_option[page]) ? c_yellow : c_white;

            draw_set_color(col_slider);
            draw_line_width(rtx, rty, rtx + len_slider, rty, 2);
            draw_circle(rtx + current_val_slider * len_slider, rty, 4, false);

            draw_text(
                rtx + len_slider * 1.2,
                rty,
                string(floor(current_val_slider * 100)) + "%"
            );
        }
        break;

        case menu_element_type.toggle:
        {
            var current_val_toggle = ds_[# 3, yy_v];
            var col_toggle = (inputting && yy_v == menu_option[page]) ? c_yellow : c_white;

            draw_set_color(col_toggle);

            if (current_val_toggle == 0)
            {
                draw_text(rtx, rty, "FULLSCREEN");
                draw_set_color(c_dkgray);
                draw_text(rtx + 110, rty, "WINDOWED");
            }
            else
            {
                draw_set_color(c_dkgray);
                draw_text(rtx, rty, "FULLSCREEN");
                draw_set_color(col_toggle);
                draw_text(rtx + 110, rty, "WINDOWED");
            }
        }
        break;

        case menu_element_type.input:
        {
            var current_val_input = ds_[# 3, yy_v];
            var current_text_input;

            switch(current_val_input)
            {
                case vk_up:    current_text_input = "UP KEY"; break;
                case vk_left:  current_text_input = "LEFT KEY"; break;
                case vk_right: current_text_input = "RIGHT KEY"; break;
                case vk_down:  current_text_input = "DOWN KEY"; break;
                case vk_escape: current_text_input = "ESC"; break;
                default:
                    current_text_input = chr(current_val_input);
            }

            var col_input = (inputting && yy_v == menu_option[page]) ? c_yellow : c_white;

            draw_set_color(col_input);

            if (inputting && yy_v == menu_option[page])
                draw_text(rtx, rty, "[ PRESS KEY ]");
            else
                draw_text(rtx, rty, current_text_input);
        }
        break;
    }
}

// titulo da pagina
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(235, 230, 185));
var page_title = "SETTINGS";
switch (page)
{
    case menu_page.settings:   page_title = "SETTINGS"; break;
    case menu_page.audio:      page_title = "AUDIO"; break;
    case menu_page.difficulty: page_title = "DIFFICULTY"; break;
    case menu_page.graphics:   page_title = "GRAPHICS"; break;
    case menu_page.controls:   page_title = "CONTROLS"; break;
}
draw_text(gwidth * 0.5, 72, page_title);

// ajuda
draw_set_color(make_color_rgb(165, 165, 155));
draw_text(gwidth * 0.5, gheight - 38, "W/S  NAVIGAR    ENTER  SELECIONAR    X  VOLTAR");

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
