/// @description Crawler — Initialize
event_inherited(); // runs oEnemy Create — sets enemy_health, hit_flash, i_frames etc

// Inherited from oEnemy parent:
// enemy_health, hit_flash, i_frames, vsp

enemy_health = 2;   // dies in 2 hits
hsp          = 1.5; // patrol speed — positive = moving right
vsp          = 0;

// Detection
wall_check_dist  = 1;  // pixels ahead to check for wall
ledge_check_dist = 8;  // pixels ahead and below to check for ledge