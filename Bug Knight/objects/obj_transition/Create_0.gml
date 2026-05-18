/// @description Transition — Initialize
instance_persistent = true;

alpha        = 0;        // current overlay alpha
fade_speed   = 0.04;     // how fast it fades
fading_out   = false;    // true = fading to black
fading_in    = false;    // true = fading from black
target_room  = -1;       // room to go to after fade out

// Singleton
if instance_number(obj_transition) > 1 {
    instance_destroy();
    exit;
}