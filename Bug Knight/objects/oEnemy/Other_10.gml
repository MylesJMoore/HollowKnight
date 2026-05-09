/// @description Enemy — Take Hit
if enemy_health <= 0 exit; // already dead — ignore hit

enemy_health--;
hit_flash = 8;

if enemy_health <= 0 {
    instance_destroy();
}