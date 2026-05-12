/// @description Enemy — Physics + Collision

#region Gravity + Collision
vsp = min(vsp + 0.5, 10);

if place_meeting(x, y + vsp, oPhysicalObject) {
    while !place_meeting(x, y + sign(vsp), oPhysicalObject) {
        y += sign(vsp);
    }
    vsp = 0;
} else {
    y += vsp;
}
#endregion

#region Knight Collision — deal damage on touch
if i_frames <= 0 && place_meeting(x, y, oKnight) {
    // damage knight
    with (oKnight) {
	    if i_frames <= 0 && health_current > 0 {
	        health_current--;
	        i_frames = i_frames_max;
	        hit_flash = hit_flash_max;
        
	        var _dir = sign(x - other.x);
	        hsp = _dir * 4;
	        vsp = -4;
        
	        // Damage particles and shake
	        spawn_particles(x, y, 8,
	            make_color_rgb(255, 80, 80),
	            1, 3,
	            2, 4,
	            "Particles"
	        );
	        screenshake(5); // bigger shake on player hit
	    }
	}
}
#endregion

#region Hit Flash Timer
if hit_flash > 0 hit_flash--;
#endregion