/// @description Breakable — Draw
draw_self();

if hit_flash > 0 {
    draw_set_color(c_white);
    draw_set_alpha(hit_flash / hit_flash_max * 0.8);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1);
    hit_flash--;
}