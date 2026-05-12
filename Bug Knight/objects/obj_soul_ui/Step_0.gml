/// @description Soul UI — Step

// Screen shake — applies offset to camera
if shake_intensity > shake_min {
    shake_intensity *= shake_decay;
    
    var _cam = view_camera[0];
    var _ox  = random_range(-shake_intensity, shake_intensity);
    var _oy  = random_range(-shake_intensity, shake_intensity);
    
    camera_set_view_pos(_cam,
        camera_get_view_x(_cam) + _ox,
        camera_get_view_y(_cam) + _oy
    );
} else {
    shake_intensity = 0;
}