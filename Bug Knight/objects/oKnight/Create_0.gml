/// @description Knight — Initialize

#region Movement
hsp = 0;
vsp = 0;
move_speed = 4;       // HK feels slower and more deliberate
accel_ground = 4;     // instant — ground acceleration matches move_speed
accel_air    = 0.2;   // low = heavy committed air movement, closer to HK feel
friction_air = 0.85;  // air bleed — lower = more carry
fast_fall_speed = 0.8; // extra gravity when holding down
#endregion

#region Jump
jump_force     = -11;
gravity_val    = 0.5;
max_fall_speed = 14;
fast_fall_max  = 18;  // higher terminal velocity during fast fall
#endregion

#region Jump State
can_jump       = false; // only true when on ground
jump_held      = false;
jump_buffer    = 0;
jump_buffer_max = 6;
was_on_ground = false;
#endregion

#region State
on_ground  = false;
facing     = 1;       // 1 = right, -1 = left
fast_fall  = false;   // true when holding down in air
#endregion

#region Wall Jump
on_wall_left  = false; // touching wall on left
on_wall_right = false; // touching wall on right
wall_slide_speed = 2;  // max fall speed while wall sliding
wall_jump_hsp    = 5;  // horizontal force on wall jump
wall_jump_vsp    = -10; // vertical force on wall jump
wall_jump_lock   = 0;  // frames of forced direction after wall jump
wall_jump_lock_max = 22;
#endregion

#region Combat
nail_damage    = 1;
nail_cooldown  = 0;       // frames until next swing allowed
nail_cd_max    = 18;      // ~0.3s at 60fps — HK's nail cooldown feel
nail_active    = false;   // true while hitbox is out
nail_duration  = 0;       // frames hitbox stays active
nail_dur_max   = 20;       // how long the swing hitbox exists
nail_hitbox_dur = 8; // keep hitbox tight
nail_dir       = 0;       // 0=right 1=left 2=up 3=down
nail_bounce_force = -13;   // upward force when nail bouncing off enemy
#endregion

#region Soul
soul_max     = 99;
soul_current = 0;
soul_per_hit = 11; // HK gives 11 soul per nail hit (3 hits = 1 spell)
#endregion

#region Health
health_max     = 5;   // 5 masks like early HK
health_current = 5;
i_frames       = 0;   // invincibility frames after taking damage
i_frames_max   = 60; // 1 second of i-frames
#endregion

#region Hit Flash
hit_flash    = 0;    // frames of white overlay
hit_flash_max = 8;
#endregion

#region Camera
// Camera setup
shake_min = 0.5;
var _cam = view_camera[0];
camera_set_view_size(_cam, 480, 270); // HK's internal resolution feel
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);
camera_set_view_pos(_cam,
    clamp(x - _cam_w / 2, 0, room_width  - _cam_w),
    clamp(y - _cam_h / 2, 0, room_height - _cam_h)
);

display_set_gui_size(1280, 720);
#endregion

#region Particles
// Walk particles
walk_particle_timer = 0;
walk_particle_rate  = 8;

// Jump particles
jump_particle_count  = 8;
jump_particle_min_spd = 1;
jump_particle_max_spd = 4;
jump_particle_min_size = 1;
jump_particle_max_size = 4;
jump_particle_color  = make_color_rgb(80, 80, 80);

// Wall jump particles
wall_particle_count  = 6;
wall_particle_color  = make_color_rgb(100, 100, 100);
#endregion