/// @description Transition — Draw Overlay

if alpha <= 0 exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_color(c_black);
draw_set_alpha(alpha);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);