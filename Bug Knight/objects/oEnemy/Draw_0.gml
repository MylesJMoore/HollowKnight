/// @description Enemy — Draw

// Flash white on hit
if hit_flash > 0 {
    draw_set_color(c_white);
} else {
    draw_set_color(c_red);
}

draw_self();