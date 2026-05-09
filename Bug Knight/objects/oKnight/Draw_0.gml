/// @description Knight — Draw

draw_self();

if nail_active {
    draw_set_color(c_blue);
    draw_set_alpha(min((nail_duration / nail_dur_max) * 3, 1)); // hold bright, quick fade at end
    
    var _size  = 20;
    var _thick = 6;
    var _ox = x;
    var _oy = y - sprite_height / 2;
    
    switch (nail_dir) {
        case 0: draw_rectangle(_ox + 4, _oy - _thick/2, _ox + 4 + _size, _oy + _thick/2, false); break;
        case 1: draw_rectangle(_ox - 4 - _size, _oy - _thick/2, _ox - 4, _oy + _thick/2, false); break;
        case 2: draw_rectangle(_ox - _thick/2, _oy - 4 - _size, _ox + _thick/2, _oy - 4, false); break;
        case 3: draw_rectangle(_ox - _thick/2, _oy + 4, _ox + _thick/2, _oy + 4 + 32, false); break;
    }
    
    draw_set_alpha(1);
}