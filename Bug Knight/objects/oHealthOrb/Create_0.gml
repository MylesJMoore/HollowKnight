/// @description Health Orb — Initialize
// Animation
sprite_index = spr_health_orb;
image_speed  = 0.15;
sprite_scale = 0.4; // tune this — smaller = tinier orb

// Physics
hsp           = 0;
vsp           = 0;
bob_timer     = random(360);
bob_speed     = 0.05;
bob_amount    = 4;
attract_range = 60;
attract_speed = 6;
health_value  = 1;
collected     = false;
gravity_val   = 0.3;
settled       = false;