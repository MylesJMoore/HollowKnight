/// @description Soul UI — Draw GUI

// Bail if knight doesn't exist
if !instance_exists(oKnight) exit;
var _kn = oKnight;

#region Health Masks
// Draw one square per max health, filled or empty
for (var _i = 0; _i < _kn.health_max; _i++) {
    var _mx = ui_x + (_i * (mask_size + mask_gap));
    var _my = ui_y;
    
    if _i < _kn.health_current {
        // Filled mask
        draw_set_color(mask_color);
        draw_set_alpha(1);
        draw_rectangle(_mx, _my, _mx + mask_size, _my + mask_size, false);
        
        // Small inner highlight
        draw_set_color(make_color_rgb(255, 120, 120));
        draw_set_alpha(0.4);
        draw_rectangle(_mx + 2, _my + 2, _mx + mask_size - 2, _my + 6, false);
    } else {
        // Empty mask — just outline
        draw_set_color(mask_empty);
        draw_set_alpha(1);
        draw_rectangle(_mx, _my, _mx + mask_size, _my + mask_size, false);
        draw_set_color(make_color_rgb(100, 40, 40));
        draw_set_alpha(1);
        draw_rectangle(_mx, _my, _mx + mask_size, _my + mask_size, true);
    }
}
#endregion

#region Soul Vessel
// Soul vessel sits below health masks
var _vy = ui_y + mask_size + 12;
var _vx = ui_x;

// Vessel background
draw_set_color(color_vessel_bg);
draw_set_alpha(1);
draw_rectangle(_vx, _vy, _vx + vessel_w, _vy + vessel_h, false);

// Soul fill — scales with current soul
var _fill_pct  = _kn.soul_current / _kn.soul_max;
var _fill_w    = floor((vessel_w - vessel_padding * 2) * _fill_pct);
var _fill_color = (_fill_pct >= 1) ? color_soul_full : color_soul_fill;

if _fill_w > 0 {
    draw_set_color(_fill_color);
    draw_set_alpha(1);
    draw_rectangle(
        _vx + vessel_padding,
        _vy + vessel_padding,
        _vx + vessel_padding + _fill_w,
        _vy + vessel_h - vessel_padding,
        false
    );
    
    // Subtle shimmer line at top of fill
    draw_set_color(c_white);
    draw_set_alpha(0.2);
    draw_rectangle(
        _vx + vessel_padding,
        _vy + vessel_padding,
        _vx + vessel_padding + _fill_w,
        _vy + vessel_padding + 2,
        false
    );
}

// Vessel border on top of everything
draw_set_color(color_vessel_border);
draw_set_alpha(1);
draw_rectangle(_vx, _vy, _vx + vessel_w, _vy + vessel_h, true);

// Soul percentage text — remove this when you have real art
draw_set_color(color_text);
draw_set_alpha(0.6);
draw_set_font(-1); // default font
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(_vx, _vy + vessel_h + 4, string(_kn.soul_current) + "/" + string(_kn.soul_max));
#endregion

#region Soul Full Indicator
// Pulse effect when soul is full — draws a glow around the vessel
if _kn.soul_current >= _kn.soul_max {
    var _pulse = (sin(current_time * 0.005) + 1) / 2; // 0 to 1 oscillation
    draw_set_color(color_soul_full);
    draw_set_alpha(_pulse * 0.4);
    draw_rectangle(_vx - 2, _vy - 2, _vx + vessel_w + 2, _vy + vessel_h + 2, true);
    draw_set_alpha(1);
}
#endregion

// Reset draw state
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);