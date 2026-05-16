/// @description Crawler — Patrol AI

#region Gravity
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

#region Patrol
var _dir = sign(hsp);

// Wall check — turn if about to hit a wall
if place_meeting(x + (wall_check_dist * _dir), y, oPhysicalObject) {
    hsp = -hsp;
    _dir = sign(hsp);
}

// Ledge check — turn if about to walk off edge
// Checks one step ahead at foot level + 1px below ground
if !place_meeting(x + (ledge_check_dist * _dir), y + 1, oPhysicalObject) {
    hsp = -hsp;
}

x += hsp;

// Face direction of travel
image_xscale = sign(hsp);
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