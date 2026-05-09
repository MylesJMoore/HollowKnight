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
            
            // Knockback away from enemy
            var _dir = sign(x - other.x);
            hsp = _dir * 4;
            vsp = -4;
        }
    }
}
#endregion

#region Hit Flash Timer
if hit_flash > 0 hit_flash--;
#endregion