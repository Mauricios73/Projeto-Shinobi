///@description create_menu_page
///@arg ["Name1",type1,entries1...]
///@arg ["Name2",type2,entries2...]
function create_menu_page() {
    var args = array_create(argument_count);
    for (var i = 0; i < argument_count; i++) {
        args[i] = argument[i];
    }

    var cols = 6;
    var rows = argument_count;
    var grid = ds_grid_create(cols, rows);

    for (var r = 0; r < rows; r++) {
        var rowArr = args[r];
        var rowLen = array_length(rowArr);
        for (var c = 0; c < min(cols, rowLen); c++) {
            grid[# c, r] = rowArr[c];
        }
    }

    return grid;
}
