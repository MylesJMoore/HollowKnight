/// @description Soul UI — Initialize

// Position — top left by default, tune per game
ui_x = 20;  // distance from left edge
ui_y = 20;  // distance from top edge

// Vessel dimensions
vessel_w = 80;  // width of soul container
vessel_h = 10;  // height of soul container
vessel_padding = 2; // inner padding between vessel wall and fill

// Colors — all swappable
color_vessel_bg     = make_color_rgb(20, 20, 40);    // dark vessel background
color_vessel_border = make_color_rgb(100, 100, 180);  // blue-grey border
color_soul_fill     = make_color_rgb(100, 180, 255);  // light blue soul fill
color_soul_full     = make_color_rgb(180, 240, 255);  // brighter when full
color_text          = c_white;

// Health mask settings
mask_size    = 14;  // size of each health square
mask_gap     = 4;   // gap between masks
mask_color   = make_color_rgb(220, 60, 60);   // red health
mask_empty   = make_color_rgb(60, 20, 20);    // dark red empty mask

// Screen shake
shake_intensity = 0;  // current shake amount in pixels
shake_decay     = 0.85; // how fast shake dies — lower = faster stop
shake_min       = 0.5;  // below this, snap to zero