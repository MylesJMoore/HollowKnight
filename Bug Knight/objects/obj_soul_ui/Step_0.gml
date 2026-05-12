/// @description Soul UI — Step
// obj_soul_ui Step — just decay, no camera movement
if shake_intensity > shake_min {
    shake_intensity *= shake_decay;
    shake_x = random_range(-shake_intensity, shake_intensity);
    shake_y = random_range(-shake_intensity, shake_intensity);
} else {
    shake_intensity = 0;
    shake_x = 0;
    shake_y = 0;
}