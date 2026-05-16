/// @description Breakable — Take Hit
if enemy_health <= 0 exit;

enemy_health--;
hit_flash = hit_flash_max;

if enemy_health <= 0 {
    spawn_particles(x, y, 14,
        make_color_rgb(160, 120, 80),
        1, 5, 2, 6, "Particles"
    );
    screenshake(3);

    // Look up drop config
    if variable_struct_exists(global.breakable_types, breakable_type) {
        var _config = variable_struct_get(global.breakable_types, breakable_type);
        var _drops  = _config.drops;

        for (var _i = 0; _i < array_length(_drops); _i++) {
            var _drop  = _drops[_i];
            var _obj   = noone;

            if _drop.type == "soul"   _obj = oSoulOrb;
            if _drop.type == "health" _obj = oHealthOrb;

            if _obj != noone {
                repeat (_drop.count) {
                    var _ox  = x + random_range(-10, 10);
                    var _oy  = y - 8;
                    var _orb = instance_create_layer(_ox, _oy, "Instances", _obj);
                    _orb.vsp = random_range(-4, -2);
                    _orb.hsp = random_range(-1.5, 1.5);
                }
            }
        }
    } else {
        show_debug_message("WARNING: breakable_type not found: " + breakable_type);
    }

    instance_destroy();
}