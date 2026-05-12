/// @description Particle — Initialize

// Movement
hsp      = 0;
vsp      = 0;
friction = 0.85; // how quickly particle slows — lower = more slide

// Appearance
size      = 4;    // starting size in pixels
size_shrink = 0.3; // how much size shrinks per frame
color     = c_orange;
alpha     = 1;
fade_speed = 0.06; // how quickly it fades out

// Lifetime
lifetime = 20; // frames before auto-destroy