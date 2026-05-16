/// @description Soul Orb — Draw
var _pulse  = (sin(bob_timer * 2) + 1) / 2;
var _bob_y = (sin(bob_timer) - 1) * bob_amount; // goes -bob*2 to 0 — only above ground

// Glow centered on draw position [HIDDEN]
/*
draw_set_color(make_color_rgb(200, 150, 255));
draw_set_alpha(0.3 + _pulse * 0.15);
draw_circle(x, y + _bob_y, 10, false);
draw_set_alpha(1);
*/

// Sprite at bobbed position
var _scale = (1 + _pulse * 0.1) * sprite_scale;
draw_sprite_ext(
    sprite_index, image_index,
    x, y + _bob_y,
    _scale, _scale,
    0, c_white, 1
);