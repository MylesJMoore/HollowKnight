/// @description Enemy — Take Hit
if enemy_health <= 0 exit; // already dead — ignore hit

enemy_health--;
hit_flash = 8;

if enemy_health <= 0 {
    if enemy_health <= 0 {
	    // Death burst
	    spawn_particles(x, y, 12,
	        make_color_rgb(220, 60, 60), // red enemy color
	        1, 5,
	        2, 6,
	        "Instances"
	    );
	    screenshake(4);
	    instance_destroy();
	}
}