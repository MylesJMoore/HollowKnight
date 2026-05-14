/// @description Particle — Update

// Movement with friction
hsp *= friction;
vsp *= friction;
x += hsp;
y += vsp;

// Gravity — reduced so walk dust floats up slightly before settling
//vsp += 0.04; // was 0.1 — much gentler, particles rise before falling

// Shrink and fade
size  = max(size - size_shrink, 0);
alpha = max(alpha - fade_speed, 0);

// Lifetime
lifetime--;
if lifetime <= 0 || alpha <= 0 || size <= 0 {
    instance_destroy();
}