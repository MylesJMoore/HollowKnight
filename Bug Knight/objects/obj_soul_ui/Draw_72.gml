/// @description Apply screen shake via view offset

if !instance_exists(obj_soul_ui) exit;

var _cam = view_camera[0];
camera_set_view_pos(_cam,
    camera_get_view_x(_cam) + shake_x,
    camera_get_view_y(_cam) + shake_y
);