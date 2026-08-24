// Só trava pelo pause quando este menu estiver em modo PAUSE.
// No menu principal (main) ele deve rodar normal.
if (variable_global_exists("game_over") && global.game_over) exit;

if (variable_global_exists("menu_mode")) {
    if (global.menu_mode == "pause" && !global.pause) exit;
} else {
    // fallback antigo
    if (!global.pause) exit;
}

var gwidth = global.view_width, gheight = global.view_height;
var is_pause_menu = variable_global_exists("menu_mode") && global.menu_mode == "pause";

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

    var font_menu = asset_get_index("fnt_asian_ninja");
    draw_set_font(font_menu != -1 ? font_menu : -1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);
    draw_text(pause_gw * 0.5 + 2, py + 72, "PAUSE");
    draw_set_color(make_color_rgb(185, 22, 22));
    draw_text(pause_gw * 0.5, py + 70, "PAUSE");

    var y_gap = 44;
    var start_y_pause = py + 158;

    for (var ip = 0; ip < ds_pause_height; ip++)
    {
        var txt = ds_pause[# 0, ip];
        var col = (ip == menu_option[page]) ? c_yellow : c_white;
        var xoff = (ip == menu_option[page]) ? -8 : 0;

        draw_set_color(c_black);
        draw_text(pause_gw * 0.5 + xoff + 2, start_y_pause + ip * y_gap + 2, txt);
        draw_set_color(col);
        draw_text(pause_gw * 0.5 + xoff, start_y_pause + ip * y_gap, txt);
    }

    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    exit;
}

//Draw Pause Menu "Back"
if (!is_pause_menu)
{
    var c = c_black;
    draw_rectangle_color(0,0,gwidth, gheight, c,c,c,c, false);
}

//Draw elements on Left Side
draw_set_valign(fa_middle);
draw_set_halign(fa_right);

var ds_ = menu_pages[page], ds_height = ds_grid_height(ds_);
var y_buffer = 32, x_buffer = 16; 
var start_y = (gheight/2) - ((((ds_height-1)/2)*y_buffer)), start_x = gwidth/2;
var ltx = start_x - x_buffer, lty, c, xo;
var yy = 0; repeat(ds_height){
	lty = start_y + (yy*y_buffer);
	c = c_white;
	xo = 0;
	
	if(yy == menu_option[page]) {
		c = c_yellow;	
		xo = -x_buffer/2;
	}
	draw_text_color(ltx + xo, lty, ds_[# 0, yy], c,c,c,c, 1);
	yy++;
}

//Draw Dividing Line
draw_line(start_x, start_y - y_buffer, start_x, lty + y_buffer);

//Draw Options on Right Side
draw_set_halign(fa_left);
var rtx = start_x + x_buffer, rty;

yy = 0; repeat(ds_height){
	rty = start_y + (yy*y_buffer);
	
	switch(ds_[# 1, yy]){
		case menu_element_type.shift:
			var current_val = ds_[# 3, yy];
			var current_val_words = ds_[# 4, yy];
			var left_shift = "<< ";
			var right_shift = " >>";
			var c = c_white;
			
			if(current_val == 0) left_shift = "";
			if(current_val == array_length_1d(ds_[# 4, yy])-1) right_shift = "";
			
			if(inputting and yy == menu_option[page]){ c = c_yellow; }
			draw_text_color(rtx, rty, left_shift + current_val_words[current_val] + right_shift, c,c,c,c, 1); 

		break;
		
		case menu_element_type.slider:
			c = c_white;
			var len = 64;
			var current_val = ds_[# 3, yy];
			draw_line_width(rtx, rty, rtx + len, rty, 2);
			
			if(inputting and yy == menu_option[page]){ c = c_yellow; }
			draw_circle_color(rtx + (current_val * len), rty, 4, c,c, false);
			draw_text_color(rtx + (len*1.2), rty, string( floor(current_val*100) )+"%", c,c,c,c, 1);

		break;
		
		case menu_element_type.toggle:
			c = c_white;
			var current_val = ds_[# 3, yy];
			var c1, c2;
			if(inputting and yy == menu_option[page]){ c = c_yellow; }
			
			if(current_val == 0){ c1 = c; c2 = c_dkgray; }
			else				{ c1 = c_dkgray; c2 = c; }
			
			draw_text_color(rtx, rty, "FULLSCREEN", c1,c1,c1,c1, 1);
			draw_text_color(rtx + 110, rty, "WINDOWED", c2,c2,c2,c2, 1);

		break;
		
		case menu_element_type.input:
			var current_val = ds_[# 3, yy];
			switch(current_val){
				case vk_up:		current_val = "UP KEY"; break;
				case vk_left:	current_val = "LEFT KEY"; break;
				case vk_right:	current_val = "RIGHT KEY"; break;
				case vk_down:	current_val = "DOWN KEY"; break;
				default:		current_val = chr(current_val); 
			}
			c = c_white;
			if(inputting and yy == menu_option[page]){ c = c_yellow; }
			draw_text_color(rtx, rty, current_val, c,c,c,c, 1);

		break;
	}
	
	yy++;
}
