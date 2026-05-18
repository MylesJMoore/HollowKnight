/// @description Menu — Initialize

// Make sure transition object exists
if !instance_exists(obj_transition) {
    instance_create_layer(0, 0, "Instances", obj_transition);
}

// Fade in on menu load
obj_transition.alpha    = 1;
obj_transition.fading_in = true;

// Menu items
menu_items = ["START", "CONTROLS", "OPTIONS", "QUIT"];
menu_index = 0;       // currently selected
menu_count = array_length(menu_items);

// State
show_controls = false; // true when controls screen is open
show_options  = false;

// Input cooldown — prevents too-fast navigation
input_cooldown = 0;

// Visual
title         = "BUG KNIGHT";  // game title
accent_color  = make_color_rgb(255, 60, 172);   // hot pink — LoafCentral
text_color    = make_color_rgb(232, 230, 240);   // off white
dim_color     = make_color_rgb(90, 88, 112);     // dimmed unselected
bg_color      = make_color_rgb(10, 10, 15);      // near black
cursor_blink  = 0;    // for blinking cursor

// Font — use fnt_dialogue or create fnt_menu
menu_font = fnt_dialogue;