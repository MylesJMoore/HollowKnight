/// @description Leaper — Initialize
event_inherited(); // runs oEnemy Create — sets enemy_health, hit_flash, i_frames etc

enemy_health  = 3;
hsp           = 0;
vsp           = 0;

// Detection
detect_range  = 150; // pixel range to detect knight
leap_force_h  = 4;   // horizontal leap toward knight
leap_force_v  = -9;  // vertical leap force
leap_cooldown = 0;
leap_cd_max   = 120; // frames between leaps — 2 seconds at 60fps

// State
leaping       = false;
on_ground     = false;