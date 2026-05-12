/// @description Enemy — Draw

draw_self(); // draw sprite normally first

// Draw white rectangle overlay on hit — same as knight flash
if hit_flash > 0 {
    draw_set_color(c_white);
    draw_set_alpha(hit_flash / 8 * 0.8);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1);
    hit_flash--;
}