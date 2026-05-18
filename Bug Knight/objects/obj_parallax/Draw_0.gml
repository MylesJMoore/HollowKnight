/// @description Parallax — Draw

var _cam   = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

for (var _li = 0; _li < array_length(layers); _li++) {
    var _layer = layers[_li];

    // Solid background — always fills screen
    if _layer.rects == 0 {
        draw_set_color(_layer.color);
        draw_set_alpha(_layer.alpha);
        draw_rectangle(
            _cam_x, _cam_y,
            _cam_x + _cam_w, _cam_y + _cam_h,
            false
        );
        continue;
    }

    // Parallax rectangles — offset by camera * speed
    var _offset_x = _cam_x * _layer.speed;
    var _offset_y = _cam_y * _layer.speed;

    draw_set_color(_layer.color);
    draw_set_alpha(_layer.alpha);

    // Use seed for consistent rect positions
    random_set_seed(_layer.seed);

    repeat (_layer.rects) {
        var _rx = _cam_x + random(_cam_w * 2) - _cam_w * 0.5 - (_offset_x mod _cam_w);
        var _ry = _cam_y + random(_cam_h * 2) - _cam_h * 0.5 - (_offset_y mod _cam_h);
        var _rw = random_range(20, 120);
        var _rh = random_range(40, 200);

        draw_rectangle(_rx, _ry, _rx + _rw, _ry + _rh, false);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);