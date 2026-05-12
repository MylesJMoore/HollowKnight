function spawn_particles(px, py, count, col, min_spd, max_spd, min_size, max_size, layer_name) {
    repeat (count) {
        var _p = instance_create_layer(px, py, layer_name, obj_particle);
        var _angle = random(360);
        var _speed = random_range(min_spd, max_spd);
        _p.hsp        = lengthdir_x(_speed, _angle);
        _p.vsp        = lengthdir_y(_speed, _angle);
        _p.color      = col;
        _p.size       = random_range(min_size, max_size);
        _p.size_shrink = _p.size / 15;
        _p.alpha      = 1;
        _p.lifetime   = irandom_range(12, 24);
        _p.fade_speed = random_range(0.04, 0.08);
        _p.friction   = random_range(0.80, 0.90);
    }
}

function spawn_particles_directional(px, py, count, col, min_spd, max_spd, min_size, max_size, layer_name, angle, spread) {
    repeat (count) {
        var _p = instance_create_layer(px, py, layer_name, obj_particle);
        var _a = angle + random_range(-spread, spread);
        var _speed = random_range(min_spd, max_spd);
        _p.hsp        = lengthdir_x(_speed, _a);
        _p.vsp        = lengthdir_y(_speed, _a);
        _p.color      = col;
        _p.size       = random_range(min_size, max_size);
        _p.size_shrink = _p.size / 15;
        _p.alpha      = 1;
        _p.lifetime   = irandom_range(12, 24);
        _p.fade_speed = random_range(0.04, 0.08);
        _p.friction   = random_range(0.80, 0.90);
    }
}

function screenshake(intensity) {
    if instance_exists(obj_soul_ui) {
        obj_soul_ui.shake_intensity = max(obj_soul_ui.shake_intensity, intensity);
    }
}