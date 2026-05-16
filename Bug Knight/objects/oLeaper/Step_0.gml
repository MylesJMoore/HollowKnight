/// @description Leaper — Idle + Leap AI

#region Gravity + Collision
vsp = min(vsp + 0.5, 10);

if place_meeting(x, y + vsp, oPhysicalObject) {
    while !place_meeting(x, y + sign(vsp), oPhysicalObject) {
        y += sign(vsp);
    }
    vsp = 0;
    on_ground = true;
} else {
    y += vsp;
    on_ground = false;
}

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

// Air friction
if !on_ground {
    hsp = lerp(hsp, 0, 0.05);
}
#endregion

#region Leap AI
if leap_cooldown > 0 leap_cooldown--;

if on_ground && !leaping {
    var _dist = point_distance(x, y, oKnight.x, oKnight.y);
    
    if _dist < detect_range && leap_cooldown <= 0 {
        // Leap toward knight
        var _dir = sign(oKnight.x - x);
        hsp     = leap_force_h * _dir;
        vsp     = leap_force_v;
        leaping = true;
        leap_cooldown = leap_cd_max;
        
        // Leap particles — burst downward on takeoff
        spawn_particles_directional(x, y, 6,
            make_color_rgb(180, 80, 80),
            1, 3, 1, 3,
            "Particles", 90, 50
        );
    }
}

// Reset leaping state on land
if on_ground && vsp == 0 {
    if leaping {
        leaping = false;
        // Land impact particles
        spawn_particles_directional(x, y, 5,
            make_color_rgb(180, 80, 80),
            0.5, 2, 1, 3,
            "Particles", 90, 60
        );
    }
}

// Face knight
if instance_exists(oKnight) {
    image_xscale = sign(oKnight.x - x);
}
#endregion

#region Knight Contact Damage
if place_meeting(x, y, oKnight) {
    with (oKnight) {
        if i_frames <= 0 && health_current > 0 {
            health_current--;
            i_frames = i_frames_max;
            hit_flash = hit_flash_max;
            var _dir = sign(x - other.x);
            
            // Only apply knockback if it won't clip into a wall
            var _knock_hsp = _dir * 4;
            if !place_meeting(x + _knock_hsp, y, oPhysicalObject) {
                hsp = _knock_hsp;
            } else {
                hsp = 0; // wall in the way — just stop
            }
            vsp = -4;
            
            spawn_particles(x, y, 8, make_color_rgb(255, 80, 80), 1, 3, 2, 4, "Particles");
            screenshake(5);
        }
    }
}
#endregion

#region Hit Flash
if hit_flash > 0 hit_flash--;
#endregion