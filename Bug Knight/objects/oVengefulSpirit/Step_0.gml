/// @description Vengeful Spirit — Move + Hit Check

lifetime--;
if lifetime <= 0 {
    // Poof particles on expiry
    spawn_particles(x, y, 8, color, 1, 3, 2, 5, "Particles");
    instance_destroy();
    exit;
}

// Destroy on wall collision
if place_meeting(x + hsp, y, oPhysicalObject) {
    spawn_particles(x, y, 8, color, 1, 3, 2, 5, "Particles");
    instance_destroy();
    exit;
}

x += hsp;

// Trail particles
trail_timer++;
if trail_timer >= 2 {
    trail_timer = 0;
    var _p = instance_create_layer(x, y, "Particles", obj_particle);
    _p.hsp        = 0;
    _p.vsp        = random_range(-0.3, 0.3);
    _p.color      = color;
    _p.size       = size * 0.6;
    _p.size_shrink = 0.4;
    _p.alpha      = 0.6;
    _p.lifetime   = 8;
    _p.fade_speed = 0.1;
    _p.friction   = 0.9;
}

// Hit check against enemies
var _x1 = bbox_left;
var _x2 = bbox_right;
var _y1 = bbox_top;
var _y2 = bbox_bottom;

with (oEnemy) {
    var _already_hit = false;
    for (var _i = 0; _i < array_length(other.hit_list); _i++) {
        if other.hit_list[_i] == id {
            _already_hit = true;
            break;
        }
    }
    if _already_hit continue;

    var _overlapping = (_x1 < bbox_right) && (_x2 > bbox_left)
                    && (_y1 < bbox_bottom) && (_y2 > bbox_top);

    if _overlapping {
        array_push(other.hit_list, id);

        // Hit particles
        spawn_particles(x, y, 8,
            make_color_rgb(200, 150, 255),
            1, 4, 2, 5, "Particles"
        );
        screenshake(3);

        var _enemy_id = id;
        with (_enemy_id) {
            event_user(0);
        }

        // Destroy on hit
        with (other) {
            spawn_particles(x, y, 8, color, 1, 3, 2, 5, "Particles");
            instance_destroy();
        }
        exit;
    }
}