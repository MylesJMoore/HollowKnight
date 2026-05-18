/// @description Parallax — Initialize

// Layer depths — 0.0 = stationary, 1.0 = moves with camera
// Lower value = further away = less movement = more parallax
layers = [
    // { color, alpha, speed, rect_count, seed }
    { color: make_color_rgb(15, 12, 25),  alpha: 1.0, speed: 0.0,  rects: 0,  seed: 0   }, // solid bg
    { color: make_color_rgb(25, 18, 45),  alpha: 0.8, speed: 0.15, rects: 8,  seed: 100 }, // far layer
    { color: make_color_rgb(35, 25, 60),  alpha: 0.6, speed: 0.30, rects: 12, seed: 200 }, // mid layer
    { color: make_color_rgb(45, 32, 75),  alpha: 0.4, speed: 0.50, rects: 10, seed: 300 }, // near layer
];

depth = 10000; // draw behind everything