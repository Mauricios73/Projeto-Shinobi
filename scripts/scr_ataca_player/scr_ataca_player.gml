///@arg player
///@arg dist
///@arg xscale

var outro = argument0;
var dist = argument1;
var xscale = argument2;

//checando linha de visão 

function scr_ataca_player(outro, dist, xscale) {
    //checando linha de visão 
    var player = collision_line(x, y - sprite_height/2, x + (dist * xscale), y - sprite_height/2, outro, false, true);

    if (player){
        estado = "ataque";  
    }
}
