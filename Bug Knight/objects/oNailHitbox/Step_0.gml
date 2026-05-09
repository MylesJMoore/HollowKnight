/// @description Nail Hitbox — Check Hits

lifetime--;
if lifetime <= 0 {
    instance_destroy();
    exit;
}

if !instance_exists(owner) {
    instance_destroy();
    exit;
}

// Store locals before with block — avoids context confusion
var _swing_dir = swing_dir;
var _owner     = owner;

with (oEnemy) {
    // Skip if already hit this swing
    var _already_hit = false;
    for (var _i = 0; _i < array_length(other.hit_list); _i++) {
        if other.hit_list[_i] == id {
            _already_hit = true;
            break;
        }
    }
    if _already_hit continue;

    // Direct bbox overlap — other = hitbox, self = enemy
    var _hx1 = other.bbox_left;
    var _hx2 = other.bbox_right;
    var _hy1 = other.bbox_top;
    var _hy2 = other.bbox_bottom;

    var _ex1 = bbox_left;
    var _ex2 = bbox_right;
    var _ey1 = bbox_top;
    var _ey2 = bbox_bottom;

    var _overlapping = (_hx1 < _ex2) && (_hx2 > _ex1) && (_hy1 < _ey2) && (_hy2 > _ey1);

    if _overlapping {
	    array_push(other.hit_list, id);
    
	    // Store ref before potentially destroying
	    var _enemy_id = id;
    
	    // Give soul
	    var _kn = _owner;
	    _kn.soul_current = min(_kn.soul_current + _kn.soul_per_hit, _kn.soul_max);
    
	    // Bounce / recoil
	    if _swing_dir == 3 {
	        _kn.vsp = _kn.nail_bounce_force;
	    }
	    if _swing_dir != 3 {
	        var _recoil = 2;
	        if _swing_dir == 0 _kn.hsp = -_recoil;
	        if _swing_dir == 1 _kn.hsp =  _recoil;
	        if _swing_dir == 2 _kn.vsp =  _recoil;
	    }
    
	    // Damage enemy last — after all other logic
	    with (_enemy_id) {
	        event_user(0);
	    }
	}
}