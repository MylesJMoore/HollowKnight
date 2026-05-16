/// @description Soul Orb — Initialize
// Animation
sprite_index = spr_soul_orb;
image_speed  = 0.15; // gentle animation if sprite has frames
sprite_scale = 0.4; // tune this — smaller = tinier orb


// Physics
hsp           = 0;
vsp           = 0;
bob_timer     = random(360); // offset so orbs don't all bob in sync
bob_speed     = 0.06;
bob_amount    = 4;
attract_range = 60;   // pixels — when knight gets this close, fly to them
attract_speed = 6;    // speed when flying toward knight
soul_value    = 33;   // soul restored on pickup
collected     = false;

// Settle after spawn pop
gravity_val   = 0.3;
on_ground     = false;
settled       = false;