/// @description Nail Hitbox — Initialize

owner      = noone; // oKnight instance that spawned this
swing_dir  = 0;     // 0=right 1=left 2=up 3=down
lifetime   = 0;     // frames before auto-destroy
damage     = 1;
hit_list   = [];    // instances already hit this swing — prevents double hit