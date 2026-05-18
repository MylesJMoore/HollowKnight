/// @description Menu — Input

// Don't process input during transition
if instance_exists(obj_transition) {
    if obj_transition.fading_out exit;
}

if input_cooldown > 0 {
    input_cooldown--;
    exit;
}

var _gp = 0;
var _up    = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"))
             || (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_padu));
var _down  = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))
             || (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_padd));
var _confirm = keyboard_check_pressed(vk_return) || keyboard_check_pressed(ord("E"))
               || (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_face1));
var _back  = keyboard_check_pressed(vk_escape)
             || (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_face2));

cursor_blink++;

// ---- CONTROLS SCREEN ----
if show_controls {
    if _back || _confirm {
        show_controls = false;
        input_cooldown = 10;
    }
    exit;
}

// ---- OPTIONS SCREEN ----
if show_options {
    if _back || _confirm {
        show_options = false;
        input_cooldown = 10;
    }
    exit;
}

// ---- MAIN MENU ----
if _up {
    menu_index = (menu_index - 1 + menu_count) mod menu_count;
    input_cooldown = 8;
}

if _down {
    menu_index = (menu_index + 1) mod menu_count;
    input_cooldown = 8;
}

if _confirm {
    switch (menu_items[menu_index]) {
        case "START":
            transition_to(rm_test);
        break;
        case "CONTROLS":
            show_controls = true;
            input_cooldown = 10;
        break;
        case "OPTIONS":
            show_options = true;
            input_cooldown = 10;
        break;
        case "QUIT":
            game_end();
        break;
    }
}