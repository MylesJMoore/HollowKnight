/// @description Vengeful Spirit — Initialize

owner    = noone;
hsp      = 8;       // set by knight on spawn
facing   = 1;       // set by knight on spawn
lifetime = 180;     // frames before auto-destroy — ~3 seconds
damage   = 1;
hit_list = [];      // enemies already hit

// Visual
trail_timer = 0;
color       = make_color_rgb(200, 150, 255); // purple
size        = 12;