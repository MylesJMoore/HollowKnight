/// @description Soul Orb — Bob + Attract + Collect

if collected exit;

#region Settle After Spawn
if !settled {
    vsp = min(vsp + gravity_val, 8);
    
    if place_meeting(x, y + vsp, oPhysicalObject) {
        while !place_meeting(x, y + sign(vsp), oPhysicalObject) {
            y += sign(vsp);
        }
        vsp  = 0;
        hsp  = 0;
        settled = true;
    } else {
        x += hsp;
        y += vsp;
        hsp = lerp(hsp, 0, 0.15); // slow horizontal drift
    }
    exit;
}
#endregion

#region Bob
bob_timer += bob_speed;
// Don't move y directly — store offset for Draw only
#endregion

#region Attract + Collect
if instance_exists(oKnight) {
    var _dist = point_distance(x, y, oKnight.x, oKnight.y);

    if _dist < attract_range {
        // Fly toward knight
        var _angle = point_direction(x, y, oKnight.x, oKnight.y);
        x += lengthdir_x(attract_speed, _angle);
        y += lengthdir_y(attract_speed, _angle);

        // Collect on overlap
        if _dist < 12 {
            collected = true;
            oKnight.soul_current = min(
                oKnight.soul_current + soul_value,
                oKnight.soul_max
            );
            // Collect particles
            spawn_particles(x, y, 6,
                make_color_rgb(200, 150, 255),
                1, 3, 1, 3, "Particles"
            );
            instance_destroy();
        }
    }
}
#endregion