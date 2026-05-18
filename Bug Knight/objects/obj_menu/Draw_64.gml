/// @description Menu - Draw GUI

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Background
draw_set_color(bg_color);
draw_set_alpha(1);
draw_rectangle(0, 0, _gw, _gh, false);

draw_set_font(menu_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ---- CONTROLS SCREEN ----
if show_controls {
    #region Controls
    // Title
    draw_set_color(accent_color);
    draw_set_alpha(1);
    draw_text(60, 60, "// CONTROLS");

    var _cx = 60;
    var _cy = 130;
    var _gap = 44;

    var _controls = [
        ["MOVE",       "A / D  or  LEFT / RIGHT"],
        ["JUMP",       "SPACE  or  A BUTTON"],
        ["WALL JUMP",  "JUMP while on wall"],
        ["FAST FALL",  "S / DOWN in air"],
        ["NAIL",       "Z  or  X BUTTON"],
        ["NAIL UP",    "W + Z  or  UP + X"],
        ["NAIL DOWN",  "S + Z in air"],
        ["SPELL",      "Q  or  LT"],
        ["NAIL BOUNCE","Nail DOWN on enemy"],
    ];

    for (var _i = 0; _i < array_length(_controls); _i++) {
        draw_set_color(dim_color);
        draw_set_alpha(1);
        draw_text(_cx, _cy + (_i * _gap), _controls[_i][0]);
        draw_set_color(text_color);
        draw_text(_cx + 200, _cy + (_i * _gap), _controls[_i][1]);
    }

    // Back prompt
    draw_set_color(dim_color);
    draw_set_alpha(0.6);
    draw_text(_cx, _gh - 60, "BACK  -  E or B BUTTON");
    #endregion
    exit;
}

// ---- OPTIONS SCREEN ----
if show_options {
    #region Options
    draw_set_color(accent_color);
    draw_set_alpha(1);
    draw_text(60, 60, "// OPTIONS");

    draw_set_color(dim_color);
    draw_set_alpha(0.8);
    draw_text(60, 130, "No options yet. Coming soon.");

    draw_set_color(dim_color);
    draw_set_alpha(0.6);
    draw_text(60, _gh - 60, "BACK  -  E or B BUTTON");
    #endregion
    exit;
}

// ---- MAIN MENU ----
#region Title
// Eyebrow
draw_set_color(dim_color);
draw_set_alpha(0.6);
draw_text(60, 60, "// LOAFCENTRAL");

// Title
draw_set_color(text_color);
draw_set_alpha(1);
draw_text(60, 100, title);

// Accent line under title
draw_set_color(accent_color);
draw_set_alpha(1);
draw_rectangle(60, 156, 60 + 120, 158, false);
#endregion

#region Menu Items
var _start_y = 200;
var _item_gap = 52;

for (var _i = 0; _i < menu_count; _i++) {
    var _selected = (_i == menu_index);
    var _item_y   = _start_y + (_i * _item_gap);

    if _selected {
        // Accent bar on left
        draw_set_color(accent_color);
        draw_set_alpha(1);
        draw_rectangle(52, _item_y + 4, 56, _item_y + 30, false);

        // Blinking cursor
        var _blink = (cursor_blink mod 40) < 20;
        if _blink {
            draw_set_color(accent_color);
            draw_set_alpha(0.5);
            draw_text(64, _item_y, ">");
        }

        // Selected text - hot pink
        draw_set_color(accent_color);
        draw_set_alpha(1);
        draw_text(80, _item_y, menu_items[_i]);

        // Subtle highlight row
        draw_set_color(accent_color);
        draw_set_alpha(0.06);
        draw_rectangle(0, _item_y - 4, _gw, _item_y + 36, false);

    } else {
        // Unselected - dimmed
        draw_set_color(dim_color);
        draw_set_alpha(1);
        draw_text(80, _item_y, menu_items[_i]);
    }
}
#endregion

#region Footer
// Bottom left - version or build info
draw_set_color(dim_color);
draw_set_alpha(0.4);
draw_text(60, _gh - 40, "v0.1  //  HK PROTOTYPE");
#endregion

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);