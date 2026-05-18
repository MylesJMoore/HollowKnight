/// @description Knight Movement

#region Input
var _gp = 0; // gamepad slot

// Gamepad connected — use it
if gamepad_is_connected(_gp) {
    key_left      = !casting && (gamepad_button_check(_gp, gp_padl) || gamepad_axis_value(_gp, gp_axislh) < -0.3);
    key_right     = !casting && (gamepad_button_check(_gp, gp_padr) || gamepad_axis_value(_gp, gp_axislh) > 0.3);
    key_up        = gamepad_button_check(_gp, gp_padu) || gamepad_axis_value(_gp, gp_axislv) < -0.3;
    key_down      = gamepad_button_check(_gp, gp_padd) || gamepad_axis_value(_gp, gp_axislv) > 0.3;
    key_jump      = !casting && gamepad_button_check_pressed(_gp, gp_face1);
    key_jump_held = !casting && gamepad_button_check(_gp, gp_face1);
    key_nail      = !casting && gamepad_button_check_pressed(_gp, gp_face3);
    key_spell     = gamepad_button_check_pressed(_gp, gp_shoulderlb);
} else {
    key_left      = !casting && (keyboard_check(vk_left)  || keyboard_check(ord("A")));
    key_right     = !casting && (keyboard_check(vk_right) || keyboard_check(ord("D")));
    key_up        = keyboard_check(vk_up)    || keyboard_check(ord("W"));
    key_down      = keyboard_check(vk_down)  || keyboard_check(ord("S"));
    key_jump      = !casting && keyboard_check_pressed(vk_space);
    key_jump_held = !casting && keyboard_check(vk_space);
    key_nail      = !casting && keyboard_check_pressed(ord("Z"));
    key_spell     = keyboard_check_pressed(ord("Q"));
}
#endregion

#region Collision State
on_ground     = place_meeting(x, y + 1, oPhysicalObject);
on_wall_left  = place_meeting(x - 1, y, oPhysicalObject) && !on_ground;
on_wall_right = place_meeting(x + 1, y, oPhysicalObject) && !on_ground;
var _on_wall  = on_wall_left || on_wall_right;
#endregion

#region Horizontal Movement
var _move = key_right - key_left;

// Wall cling — don't let horizontal input pull you off wall immediately
var _clinging = _on_wall && !on_ground && vsp > 0;

if wall_jump_lock > 0 {
    wall_jump_lock--;
    var _move = key_right - key_left;
    if _move != 0 {
        hsp = approach(hsp, move_speed * _move, 0.08);
    }
} else if _clinging {
    // While clinging — only allow input TOWARD the wall, not away
    var _move = key_right - key_left;
    var _wall_dir = on_wall_left ? -1 : 1; // direction wall is on
    if sign(_move) == _wall_dir {
        // pressing into wall — stay clung, just zero hsp
        hsp = 0;
    }
    // pressing away or no input — do nothing, let jump handle it
} else {
    var _move = key_right - key_left;
    if _move != 0 {
        facing = sign(_move);
        if on_ground {
            hsp = move_speed * _move;
        } else {
            hsp = approach(hsp, move_speed * _move, accel_air);
        }
    } else {
        if on_ground {
            hsp = 0;
        } else {
            hsp = lerp(hsp, 0, 1 - friction_air);
        }
    }
}
#endregion

#region Jump Buffer
if key_jump {
    jump_buffer = jump_buffer_max;
} else {
    jump_buffer = max(jump_buffer - 1, 0);
}
#endregion

#region Jump
if on_ground {
    can_jump = true;
    fast_fall = false;
}

// Regular jump — particles shoot downward and sideways (knight pushes off ground)
if jump_buffer > 0 && can_jump {
    vsp = jump_force;
    can_jump = false;
    jump_buffer = 0;
    jump_held = true;

    // Downward burst — dust kicked off the ground going down and out
    spawn_particles_directional(x, y,
        jump_particle_count,
        jump_particle_color,
        jump_particle_min_spd, jump_particle_max_spd,
        jump_particle_min_size, jump_particle_max_size,
        "Particles",
        90,  // 90 = downward in GML (y increases downward)
        60   // 60 degree spread — wide fan of dust
    );
}

// Wall jump — particles burst away from the wall
if jump_buffer > 0 && _on_wall && !on_ground {
    vsp = wall_jump_vsp;
    jump_buffer = 0;

    if on_wall_left {
	    hsp = wall_jump_hsp;
	    facing = 1;
	    // Spawn at left edge — bbox_left is always the leftmost pixel
	    spawn_particles_directional(bbox_left, y,
	        wall_particle_count,
	        wall_particle_color,
	        1, 4, 1, 3,
	        "Particles",
	        315, // up-right diagonal away from left wall
	        50
	    );
	} else {
	    hsp = -wall_jump_hsp;
	    facing = -1;
	    // Spawn at right edge — bbox_right is always the rightmost pixel
	    spawn_particles_directional(bbox_right, y,
	        wall_particle_count,
	        wall_particle_color,
	        1, 4, 1, 3,
	        "Particles",
	        225, // up-left diagonal away from right wall
	        50
	    );
	}
    wall_jump_lock = wall_jump_lock_max;
}

// Variable jump height
if !key_jump_held && vsp < -2 {
    vsp += 0.6;
}
#endregion

#region Gravity + Fast Fall
var _grav     = gravity_val;
var _max_fall = max_fall_speed;

// Heavier gravity on the way down — lighter on the way up
// This makes the jump arc feel more natural and less floaty on ascent
if vsp > 0 && !fast_fall {
    _grav = gravity_val * 1.4; // tune this — 1.2 to 1.6 is the sweet spot
}

if _on_wall && vsp > 0 {
    _max_fall = wall_slide_speed;
    _grav     = gravity_val * 0.4; // wall slide — slow gravity while clinging
}

if fast_fall {
    _grav     = gravity_val + fast_fall_speed;
    _max_fall = fast_fall_max;
}

vsp = min(vsp + _grav, _max_fall);
#endregion

#region Nail Cooldown
if nail_cooldown > 0 nail_cooldown--;
if nail_duration > 0 nail_duration--;
if nail_duration <= 0 nail_active = false;
#endregion

#region Spell Cooldown
if spell_cooldown > 0 spell_cooldown--;

// Cast timer — knight frozen during this
if casting {
    cast_timer--;
    if cast_timer <= 0 {
        casting = false;
        // Spawn projectile when cast ends
        var _proj = instance_create_layer(x, y - sprite_height / 2, "Instances", oVengefulSpirit);
        _proj.owner   = id;
        _proj.hsp     = facing == 1 ? 8 : -8; // travel direction
        _proj.facing  = facing;
    }
}
#endregion

#region Spell Input
if key_spell && !casting && spell_cooldown <= 0 {
    if soul_current >= soul_cost_vs {
        soul_current -= soul_cost_vs;
        casting       = true;
        cast_timer    = cast_dur_max;
        spell_cooldown = spell_cd_max;
        
        spawn_particles_directional(x, y - sprite_height / 2, 6,
            make_color_rgb(200,150, 255),
            1, 3, 2, 4, "Particles", 270, 40
        );
        
        if instance_exists(obj_soul_ui) {
            obj_soul_ui.soul_flash = obj_soul_ui.soul_flash_max;
        }
    } else {
        // Not enough soul — flash vessel red as feedback
        if instance_exists(obj_soul_ui) {
            obj_soul_ui.soul_flash_color = c_red;
            obj_soul_ui.soul_flash = obj_soul_ui.soul_flash_max;
        }
    }
}
#endregion

#region Nail Input
if key_nail && nail_cooldown <= 0 {
    nail_active   = true;
    nail_duration = nail_dur_max;
    nail_cooldown = nail_cd_max;

    // Determine direction first
    if key_up {
        nail_dir = 2;
    } else if key_down && !on_ground {
        nail_dir = 3;
    } else {
        nail_dir = facing == 1 ? 0 : 1;
    }

    // Destroy old hitbox THEN spawn new one immediately
    with (oNailHitbox) {
        if owner == other.id instance_destroy();
    }

    
    var _hx = x;
    var _hy = y - sprite_height / 2;
	var _reach = 20;
	var _reach_down = 32; // bigger reach for downward nail

	switch (nail_dir) {
	    case 0: _hx += _reach;                      break;
	    case 1: _hx -= _reach;                      break;
	    case 2: _hy -= _reach;                      break;
	    case 3: _hy += _reach_down + sprite_height; break;
	}

    var _hit = instance_create_layer(_hx, _hy, "Instances", oNailHitbox);
    _hit.owner     = id;
    _hit.swing_dir = nail_dir;
    _hit.lifetime  = nail_hitbox_dur;
    _hit.damage    = nail_damage;

    if nail_dir == 0 || nail_dir == 1 {
        _hit.sprite_index = spr_nail_h;
    } else {
        _hit.sprite_index = spr_nail_v;
    }
}
#endregion

#region I-frames
if i_frames > 0 i_frames--;
#endregion

#region Collisions
var vsp_prev = vsp;
if hsp != 0 {
    if place_meeting(x + hsp, y, oPhysicalObject) {
        while !place_meeting(x + sign(hsp), y, oPhysicalObject) {
            x += sign(hsp);
        }
        hsp = 0;
    } else {
        x += hsp;
    }
}

if vsp != 0 {
    if place_meeting(x, y + vsp, oPhysicalObject) {
        while !place_meeting(x, y + sign(vsp), oPhysicalObject) {
            y += sign(vsp);
        }
        vsp = 0;
    } else {
        y += vsp;
    }
}

// Landing dust — vsp_prev captured before collisions zeroed it
if on_ground && !was_on_ground && vsp_prev > 2 {
    spawn_particles_directional(x, y, 6,
        jump_particle_color,
        1, 3, 2, 5,
        "Particles",
        90, // downward — dust splashes out on landing
        70  // wide spread
    );
}
was_on_ground = on_ground;

// Enemy body collision — push knight out, wall-aware
if place_meeting(x, y, oEnemy) {
    var _push = sign(x - oEnemy.x);
    
    // Only nudge if there's no wall in that direction
    if !place_meeting(x + (_push * 2), y, oPhysicalObject) {
        x += _push * 2;
    } else if !place_meeting(x - (_push * 2), y, oPhysicalObject) {
        // Try pushing the other way if blocked
        x -= _push * 2;
    }
    // If both directions blocked — knight is cornered, don't move
}
#endregion

#region Walk Dust
if on_ground && abs(hsp) > 0.5 {
    walk_particle_timer++;
    if walk_particle_timer >= walk_particle_rate {
        walk_particle_timer = 0;
        spawn_particles_directional(x, y, 2,
		    make_color_rgb(80, 80, 80),
		    0.5, 1.5, 1, 2,
		    "Particles",
		    150, // slightly left of straight up — rises and drifts
		    25   // narrow spread
		);
    }
} else {
    walk_particle_timer = 0;
}
#endregion

#region Draw Facing
image_xscale = facing;
#endregion

#region Death
if dead {
    death_timer--;
    if death_timer <= 0 {
        // Respawn
        dead           = false;
        health_current = health_max;
        soul_current   = 0;
        x              = spawn_x;
        y              = spawn_y;
        hsp            = 0;
        vsp            = 0;
        i_frames       = i_frames_max;
        sprite_index   = spr_knight;
        transition_to(room_current); // fade out then fade back in
    }
    exit; // skip all movement while dead
}

if health_current <= 0 && !dead {
    dead        = true;
    death_timer = death_dur;
    hsp         = 0;
    vsp         = 0;

    // Death burst
    spawn_particles(x, y, 20,
        make_color_rgb(255, 255, 255),
        2, 8, 2, 6, "Particles"
    );
    screenshake(8);

    // Trigger fade out
    transition_to(room_current);
}
#endregion

#region Camera
var _cam   = view_camera[0];
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);
var _target_x = clamp(x - _cam_w / 2, 0, room_width  - _cam_w);
var _target_y = clamp(y - _cam_h / 2, 0, room_height - _cam_h);
camera_set_view_pos(_cam,
    lerp(camera_get_view_x(_cam), _target_x, 0.15),
    lerp(camera_get_view_y(_cam), _target_y, 0.15)
);
#endregion
