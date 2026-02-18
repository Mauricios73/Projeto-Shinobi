/// @function scr_get_menu_value_string(grid, row)
/// @description Retorna o texto formatado do valor de uma opção do menu.

function scr_get_menu_value_string(_grid, _row) {
    var _type = _grid[# 1, _row];
    var _val  = _grid[# 3, _row];
    
    switch(_type) {
        case menu_element_type.shift:
            var _words = _grid[# 4, _row];
            return string(_words[_val]);
            
        case menu_element_type.slider:
            return string(floor(_val * 100)) + "%";
            
        case menu_element_type.toggle:
            return (_val == 0) ? "FULLSCREEN" : "WINDOWED";
            
        case menu_element_type.input:
            // Converte o código da tecla para um texto legível
            switch(_val) {
                case vk_up:    return "UP";
                case vk_down:  return "DOWN";
                case vk_left:  return "LEFT";
                case vk_right: return "RIGHT";
                case vk_enter: return "ENTER";
                case vk_space: return "SPACE";
                default:       return chr(_val);
            }
            
        case menu_element_type.script_runner:
        case menu_element_type.page_transfer:
            return ""; // Estes tipos não exibem valores à direita
    }
    
    return "";
}