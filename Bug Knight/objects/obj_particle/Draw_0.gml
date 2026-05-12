/// @description Particle — Draw

draw_set_color(color);
draw_set_alpha(alpha);
draw_rectangle(
    x - size / 2, y - size / 2,
    x + size / 2, y + size / 2,
    false
);
draw_set_alpha(1);