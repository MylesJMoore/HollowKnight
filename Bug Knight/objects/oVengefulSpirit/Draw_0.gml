/// @description Vengeful Spirit — Draw

// Outer glow
draw_set_color(color);
draw_set_alpha(0.3);
draw_rectangle(
    x - size, y - size / 2,
    x + size, y + size / 2,
    false
);

// Core
draw_set_color(c_navy);
draw_set_alpha(1);
draw_rectangle(
    x - size * 0.5, y - size * 0.3,
    x + size * 0.5, y + size * 0.3,
    false
);

draw_set_alpha(1);