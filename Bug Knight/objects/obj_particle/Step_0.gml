/// @description Particle — Update

// Movement with friction
hsp *= friction;
vsp *= friction;
x += hsp;
y += vsp;

// Gravity — optional, makes dust fall naturally
vsp += 0.1;

// Shrink and fade
size  = max(size - size_shrink, 0);
alpha = max(alpha - fade_speed, 0);

// Lifetime
lifetime--;
if lifetime <= 0 || alpha <= 0 || size <= 0 {
    instance_destroy();
}