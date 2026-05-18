/// @description Transition — Fade Logic

if fading_out {
    alpha += fade_speed;
    if alpha >= 1 {
        alpha = 1;
        fading_out = false;
        // Switch room then fade back in
        room_goto(target_room);
        fading_in = true;
    }
}

if fading_in {
    alpha -= fade_speed;
    if alpha <= 0 {
        alpha     = 0;
        fading_in = false;
    }
}