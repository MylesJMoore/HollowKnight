/// @description Health Orb — Bob + Attract + Collect

if collected exit;

#region Settle After Spawn
if !settled {
    vsp = min(vsp + gravity_val, 8);
    
    if place_meeting(x, y + vsp, oPhysicalObject) {
        while !place_meeting(x, y + sign(vsp), oPhysicalObject) {
            y += sign(vsp);
        }
        vsp     = 0;
        hsp     = 0;
        settled = true;
    } else {
        x += hsp;
        y += vsp;
        hsp = lerp(hsp, 0, 0.15);
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
        var _angle = point_direction(x, y, oKnight.x, oKnight.y);
        x += lengthdir_x(attract_speed, _angle);
        y += lengthdir_y(attract_speed, _angle);

        if _dist < 12 {
            collected = true;
            with (oKnight) {
                if health_current < health_max {
                    health_current++;
                    // Flash masks on heal
                    if instance_exists(obj_soul_ui) {
                        obj_soul_ui.soul_flash       = obj_soul_ui.soul_flash_max;
                        obj_soul_ui.soul_flash_color = make_color_rgb(220, 60, 60);
                    }
                }
            }
            spawn_particles(x, y, 6,
                make_color_rgb(220, 60, 60),
                1, 3, 1, 3, "Particles"
            );
            instance_destroy();
        }
    }
}
#endregion