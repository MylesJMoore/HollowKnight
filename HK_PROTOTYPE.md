# HK_PROTOTYPE - Bug Knight Complete Reference

**Project:** Bug Knight  
**Engine:** GameMaker Studio 2 (IDE 2023.11.1.129)  
**Author:** LoafCentral  
**Purpose:** Hollow Knight-inspired 2D platformer prototype  
**Internal Resolution:** 480×270 (pixel-art feel, displayed at 1280×720 GUI)

---

## Table of Contents

1. [What This Project Is](#1-what-this-project-is)
2. [Project Structure - Files and Folders](#2-project-structure--files-and-folders)
3. [Object List at a Glance](#3-object-list-at-a-glance)
4. [Script Functions Reference](#4-script-functions-reference)
5. [Object Deep Dives - Every Event Explained](#5-object-deep-dives--every-event-explained)
   - [obj_init](#obj_init)
   - [obj_transition](#obj_transition)
   - [obj_parallax](#obj_parallax)
   - [obj_menu](#obj_menu)
   - [obj_soul_ui](#obj_soul_ui)
   - [obj_particle](#obj_particle)
   - [oKnight](#oknight)
   - [oPhysicalObject](#ophysicalobject)
   - [oEnemy (parent)](#oenemy-parent)
   - [oCrawler](#ocrawler)
   - [oLeaper](#oleaper)
   - [oNailHitbox](#onailhitbox)
   - [oVengefulSpirit](#ovengefulspirit)
   - [oBreakable](#obreakable)
   - [oSoulOrb](#osoulorb)
   - [oHealthOrb](#ohealthorb)
6. [Phase Breakdown - What Was Built When](#6-phase-breakdown--what-was-built-when)
7. [Tuning Reference - Every Configurable Variable](#7-tuning-reference--every-configurable-variable)
8. [How Systems Talk to Each Other](#8-how-systems-talk-to-each-other)
9. [Rooms](#9-rooms)
10. [Porting to a New Project](#10-porting-to-a-new-project)

---

## 1. What This Project Is

Bug Knight is a **prototype** modeled closely on the game Hollow Knight. The goal was to build a solid, feel-first foundation that you can expand into a real game. It covers:

- **Movement** that matches Hollow Knight's deliberate, heavy-but-precise feel (instant ground speed, committed air control, wall jumping)
- **Combat** with a directional nail (sword) and one spell (Vengeful Spirit fireball)
- **Soul system** - a resource meter that fills as you hit enemies and drains when you cast spells
- **Two enemy types** with distinct AI patterns
- **Particle effects, screen shake, hit flash** - the polish layer that makes everything feel alive
- **Breakable objects** with configurable drop tables
- **Collectibles** (soul orbs, health orbs) with magnetic pick-up behavior
- **A full menu system** with Controls and Options screens
- **Room transitions** with fade-to-black
- **Parallax scrolling background**
- **Death and respawn** with room reload

Everything is written in GML (GameMaker Language) without any built-in physics engine - all movement, collision, and gravity are coded manually.

---

## 2. Project Structure - Files and Folders

```
Bug Knight/
├── Bug Knight.yyp          ← Main project file. Lists all resources.
│
├── objects/                ← All game objects (.yy definition + .gml events)
│   ├── obj_init/           ← Game-start initializer (persistent, runs once)
│   ├── obj_transition/     ← Fade-to-black overlay (persistent singleton)
│   ├── obj_parallax/       ← Procedural parallax background
│   ├── obj_menu/           ← Title screen / controls / options
│   ├── obj_soul_ui/        ← HUD: health masks + soul vessel + screen shake
│   ├── obj_particle/       ← Single reusable square particle
│   ├── oKnight/            ← Player character (all movement, combat, spells)
│   ├── oPhysicalObject/    ← Solid collision parent (tiles/walls inherit this)
│   ├── oEnemy/             ← Enemy parent class (health, hit flash, contact damage)
│   ├── oCrawler/           ← Patrol enemy (walks back and forth)
│   ├── oLeaper/            ← Leaping enemy (jumps at player)
│   ├── oNailHitbox/        ← Invisible hitbox spawned per nail swing
│   ├── oVengefulSpirit/    ← Fireball projectile (Vengeful Spirit spell)
│   ├── oBreakable/         ← Destructible crate with configurable drops
│   ├── oSoulOrb/           ← Soul pickup (fills spell meter)
│   └── oHealthOrb/         ← Health pickup (restores 1 mask)
│
├── scripts/                ← Standalone utility functions
│   ├── scr_approach/       ← approach() - move value toward target by amount
│   ├── scr_init/           ← init_breakable_types(), transition_to()
│   └── scr_particles/      ← spawn_particles(), spawn_particles_directional(), screenshake()
│
├── rooms/
│   ├── rm_menu/            ← Title screen room
│   └── rm_test/            ← Gameplay test room (where you play)
│
├── sprites/                ← All sprites (.png + .yy)
│   ├── spr_knight          ← Player sprite
│   ├── spr_crawler         ← Crawler enemy sprite
│   ├── spr_leaper          ← Leaper enemy sprite
│   ├── spr_soul_orb        ← Soul pickup sprite
│   ├── spr_health_orb      ← Health pickup sprite
│   ├── spr_nail_h          ← Nail hitbox sprite (horizontal)
│   └── spr_nail_v          ← Nail hitbox sprite (vertical)
│
└── fonts/
    └── fnt_dialogue        ← Font used for all text rendering
```

### Key GML File Naming Convention

Inside each object folder, events are stored as:

- `Create_0.gml` - Create event (runs once when instance is created)
- `Step_0.gml` - Step event (runs every frame, ~60fps)
- `Draw_0.gml` - Draw event (draw to the game world/camera space)
- `Draw_64.gml` - Draw GUI event (draw to screen space, ignores camera)
- `Draw_72.gml` - Post-Draw GUI event (runs after Draw GUI)
- `Other_10.gml` - User Event 0 (a custom event you can call with `event_user(0)`)

---

## 3. Object List at a Glance

| Object            | Type           | Persistent | Purpose                                         |
| ----------------- | -------------- | ---------- | ----------------------------------------------- |
| `obj_init`        | Utility        | Yes        | Initializes global data once at game start      |
| `obj_transition`  | Utility        | Yes        | Singleton fade overlay between rooms            |
| `obj_parallax`    | Visual         | No         | Procedural parallax rectangles in background    |
| `obj_menu`        | UI             | No         | Title screen with navigation, controls, options |
| `obj_soul_ui`     | HUD            | No         | Draws health masks, soul vessel, screen shake   |
| `obj_particle`    | VFX            | No         | One reusable square particle instance           |
| `oKnight`         | Player         | No         | Full player controller                          |
| `oPhysicalObject` | Collision      | -          | Parent of all solid geometry                    |
| `oEnemy`          | Enemy (parent) | No         | Base class: health, flash, contact damage       |
| `oCrawler`        | Enemy          | No         | Patrol AI - turns at walls and ledges           |
| `oLeaper`         | Enemy          | No         | Leap AI - detects and jumps at player           |
| `oNailHitbox`     | Hitbox         | No         | Temporary combat hitbox per nail swing          |
| `oVengefulSpirit` | Projectile     | No         | Vengeful Spirit fireball spell                  |
| `oBreakable`      | Prop           | No         | Destructible crate, drops items on break        |
| `oSoulOrb`        | Pickup         | No         | Soul resource pickup, magnetic                  |
| `oHealthOrb`      | Pickup         | No         | Health pickup, restores 1 mask, magnetic        |

---

## 4. Script Functions Reference

Scripts in GML are `.gml` files that contain standalone functions. They are global - any object can call them.

---

### `scr_approach.gml`

#### `approach(val, target, amount)`

Moves `val` toward `target` by `amount` without overshooting.

```
approach(3, 10, 2) → 5
approach(10, 3, 4) → 6
approach(10, 3, 10) → 3  ← clamps, never goes past target
```

**When to use:** Smooth acceleration/deceleration. Used in wall-jump horizontal momentum bleed-off - so the knight gradually regains steering control rather than snapping instantly.

**Arguments:**
| Argument | Type | Description |
|---|---|---|
| `val` | real | Current value |
| `target` | real | Value to move toward |
| `amount` | real | Maximum step size per frame |

**Returns:** The new value (does not modify in place - you must assign it).

---

### `scr_init.gml`

#### `init_breakable_types()`

Populates `global.breakable_types` - a struct that maps string keys to drop configurations. Called once by `obj_init` at game start.

```gml
global.breakable_types = {
    "crate_soul":   { drops: [{ type: "soul",   count: 2 }] },
    "crate_health": { drops: [{ type: "health", count: 1 }] },
    "crate_mixed":  { drops: [{ type: "soul",   count: 2 }, { type: "health", count: 1 }] },
    "crate_rich":   { drops: [{ type: "soul",   count: 4 }, { type: "health", count: 2 }] },
}
```

To add a new crate type, add an entry here and reference the key in a room's instance Creation Code:

```gml
// Room Creation Code for a breakable instance:
breakable_type = "crate_rich";
```

#### `transition_to(room_id)`

Triggers a fade-out then room change. Safe to call from anywhere.

```gml
transition_to(rm_test);     // go to test room
transition_to(room_current); // reload current room (used on death)
```

**How it works:** Creates `obj_transition` if it doesn't exist, then sets `fading_out = true`. The transition object handles the room switch once the fade completes, then fades back in.

---

### `scr_particles.gml`

#### `spawn_particles(px, py, count, col, min_spd, max_spd, min_size, max_size, layer_name)`

Spawns `count` square particles exploding in all directions from a point.

| Argument                | Type   | Description                                            |
| ----------------------- | ------ | ------------------------------------------------------ |
| `px, py`                | real   | World position to spawn at                             |
| `count`                 | int    | Number of particles                                    |
| `col`                   | color  | Particle color (use `make_color_rgb(r,g,b)`)           |
| `min_spd` / `max_spd`   | real   | Speed range (pixels/frame)                             |
| `min_size` / `max_size` | real   | Starting size range (pixels)                           |
| `layer_name`            | string | Layer to create on (e.g. `"Particles"`, `"Instances"`) |

Example usage - hit impact:

```gml
spawn_particles(x, y, 8, make_color_rgb(255, 200, 80), 1, 4, 2, 5, "Particles");
```

#### `spawn_particles_directional(px, py, count, col, min_spd, max_spd, min_size, max_size, layer_name, angle, spread)`

Same as `spawn_particles` but fires in a cone instead of all directions.

Extra arguments:
| Argument | Type | Description |
|---|---|---|
| `angle` | real | Center direction in degrees (0=right, 90=down, 180=left, 270=up) |
| `spread` | real | Half-angle of cone (e.g. 30 means ±30° = 60° wide cone) |

Example - jump dust (explodes downward):

```gml
spawn_particles_directional(x, y, 8, c_gray, 1, 4, 1, 4, "Particles", 90, 60);
```

**Angle reference for GML (Y increases downward):**

- `0` = right
- `90` = down
- `180` = left
- `270` = up

#### `screenshake(intensity)`

Sets the screen shake on `obj_soul_ui`. Safe to call even if `obj_soul_ui` doesn't exist.

```gml
screenshake(3);  // light shake (nail hit on enemy)
screenshake(5);  // medium (player takes damage)
screenshake(8);  // heavy (player death)
```

Shake decays over time via `shake_decay` (0.75 default - loses 25% each frame).

---

## 5. Object Deep Dives - Every Event Explained

---

### `obj_init`

**Purpose:** One-time game initializer. Place this in `rm_menu` (the first room). It persists across rooms so it only runs once.

**Events:**

#### Create

```gml
instance_persistent = true;   // survives room changes
init_breakable_types();       // populates global.breakable_types struct
```

That's the entire object. It exists solely to fire `init_breakable_types()` before any room that uses breakables loads.

---

### `obj_transition`

**Purpose:** A full-screen black overlay that fades out and in when switching rooms. It's a persistent singleton - only one should ever exist.

**Events:**

#### Create

```gml
instance_persistent = true;
alpha      = 0;       // current overlay opacity (0=invisible, 1=black)
fade_speed = 0.04;    // opacity change per frame
fading_out = false;   // currently going to black?
fading_in  = false;   // currently clearing from black?
target_room = -1;     // room to switch to mid-fade
```

Destroys itself if a duplicate exists (singleton pattern).

#### Step

Manages the two-phase fade:

1. If `fading_out`: increment `alpha`. When it reaches 1, switch to `target_room` and begin `fading_in`.
2. If `fading_in`: decrement `alpha`. When it reaches 0, done.

#### Draw GUI

Draws a black rectangle covering the entire GUI canvas when `alpha > 0`.

**How to use from code:**

```gml
transition_to(rm_test);   // call the helper function, not obj_transition directly
```

---

### `obj_parallax`

**Purpose:** Draws a layered background of colored rectangles that scroll at different speeds as the camera moves, creating a sense of depth.

**Events:**

#### Create

Defines a `layers` array. Each element is a struct:

```gml
{
    color: make_color_rgb(r, g, b),  // rectangle color
    alpha: 0.8,                       // opacity
    speed: 0.15,                      // 0.0 = fixed in place, 1.0 = moves with camera
    rects: 8,                         // how many rectangles to draw
    seed: 100                         // random seed for consistent placement
}
```

The first layer (`rects: 0`) is a solid background fill. Subsequent layers have increasing `speed` values - closer layers move faster.

`depth = 10000` - ensures it draws behind all gameplay objects.

#### Draw

Loops through every layer. For the solid layer, just fills the camera viewport. For parallax layers, uses `random_set_seed` to generate consistent rectangle positions offset by `camera_x * layer.speed`.

**Why `random_set_seed`?** Without it, rectangle positions would re-randomize every frame. Setting the same seed before generating positions means the same rectangles appear each frame, but they scroll based on camera offset.

---

### `obj_menu`

**Purpose:** The title screen. Handles the main menu list, a controls screen, and an options screen.

**Events:**

#### Create

Sets up menu state:

```gml
menu_items  = ["START", "CONTROLS", "OPTIONS", "QUIT"]
menu_index  = 0         // which item is selected
show_controls = false   // are we on the controls sub-screen?
show_options  = false
input_cooldown = 0      // prevents rapid input repeat
cursor_blink  = 0       // counter for blinking > cursor animation
```

Also ensures `obj_transition` exists and triggers a fade-in (so the menu appears gracefully when the room loads).

#### Step

Reads keyboard + gamepad input (supports both simultaneously). Uses `input_cooldown` to prevent accidental double-presses when navigating up/down.

**Control flow:**

1. If `fading_out` on transition - skip all input (prevents input during room change)
2. If `show_controls` - only respond to Back/Confirm (close the sub-screen)
3. Otherwise - Up/Down to navigate, Confirm to select

**Actions on confirm:**

- `START` → `transition_to(rm_test)`
- `CONTROLS` → `show_controls = true`
- `OPTIONS` → `show_options = true`
- `QUIT` → `game_end()`

#### Draw GUI

Draws everything to screen space (unaffected by the game camera).

Three rendering modes:

1. **Controls screen** - a table of action/key pairs
2. **Options screen** - placeholder "Coming soon" text
3. **Main menu** - title, accent line, menu items with selection highlight + blinking cursor

All colors defined in Create: `accent_color` (hot pink), `text_color` (off-white), `dim_color` (muted purple-grey), `bg_color` (near black).

---

### `obj_soul_ui`

**Purpose:** The HUD. Draws health masks and the soul vessel bar. Also owns the screen shake system.

**Events:**

#### Create

Defines all visual parameters (positions, colors, sizes) and initializes the shake system:

```gml
shake_intensity = 0    // current shake magnitude in pixels
shake_decay     = 0.75 // multiplied each frame - shake fades out
shake_min       = 0.5  // below this value, snap shake to zero
shake_x = 0            // current frame's random offset
shake_y = 0
```

Also sets up soul flash feedback:

```gml
soul_flash      = 0    // countdown timer for flash effect
soul_flash_max  = 12   // frames the flash lasts
soul_flash_color = c_white  // flash color (overridden to red on failed cast)
```

#### Step

Handles shake decay:

- If `shake_intensity > shake_min`: multiply by `shake_decay`, generate new random `shake_x`/`shake_y` offsets
- Otherwise: zero everything out

#### Draw GUI (Draw_64)

The main HUD drawing:

**Health masks:** Loops 0..`health_max-1`. Each iteration draws either a filled red square (if `i < health_current`) or an empty dark square (outline only). A small highlight rectangle sits at the top of each filled mask.

**Soul vessel:** A rectangular bar below the health masks. Inner fill scales with `soul_current / soul_max`. Shows a subtle shimmer line. Has a pulsing purple glow outline when completely full.

**Soul flash:** A temporary color overlay on the vessel - white when a spell is cast, red when a spell is attempted without enough soul.

#### Post-Draw GUI (Draw_72)

Applies the shake offset to the camera view position:

```gml
camera_set_view_pos(_cam,
    camera_get_view_x(_cam) + shake_x,
    camera_get_view_y(_cam) + shake_y
);
```

This runs after Draw GUI so the shake doesn't offset UI elements - only the game world.

---

### `obj_particle`

**Purpose:** A single square particle. Many of these are spawned by `spawn_particles()` and `spawn_particles_directional()`. Each one manages its own life.

**Events:**

#### Create

All defaults - these are overridden immediately by the spawn functions:

```gml
hsp = 0; vsp = 0
friction  = 0.85   // velocity multiplier per frame
size      = 4      // pixels wide/tall
size_shrink = 0.3  // subtracted from size per frame
color     = c_orange
alpha     = 1
fade_speed = 0.06  // subtracted from alpha per frame
lifetime  = 20     // frames until forced destroy
```

#### Step

Each frame:

1. Multiply `hsp` and `vsp` by `friction` (slows down)
2. Move by `hsp`, `vsp`
3. Shrink `size`, fade `alpha`
4. Decrement `lifetime`
5. Destroy when `lifetime <= 0` OR `alpha <= 0` OR `size <= 0`

Note: Gravity is commented out. Particles float and drift instead of falling. Uncomment `vsp += 0.04` in Step if you want falling particles.

#### Draw

Draws a filled rectangle centered on `x, y` with side length `size`, using `color` at `alpha`.

---

### `oKnight`

**Purpose:** The player character. This is the largest and most complex object in the project.

**Events:**

#### Create

Organizes all variables into `#region` blocks:

**Movement variables:**

```
hsp / vsp           horizontal and vertical speed (pixels/frame)
move_speed = 4      max ground speed
accel_ground = 4    ground acceleration (instant - set directly)
accel_air = 0.2     air acceleration (gradual - added per frame)
friction_air = 0.85 air friction (multiplied when no input)
fast_fall_speed = 0.8 extra gravity added when holding down
```

**Jump variables:**

```
jump_force = -11    initial vsp on jump (negative = upward)
gravity_val = 0.5   gravity added per frame on ascent
max_fall_speed = 14 terminal velocity
fast_fall_max = 18  terminal velocity during fast fall
```

**Jump state:**

```
can_jump            true only when on ground
jump_buffer = 6     coyote/buffer frames - you can press jump slightly before landing
was_on_ground       previous frame ground state (for landing detection)
```

**Wall jump:**

```
on_wall_left / on_wall_right   collision state
wall_slide_speed = 2           max fall speed while sliding down a wall
wall_jump_hsp = 5              horizontal force on wall jump
wall_jump_vsp = -10            vertical force on wall jump
wall_jump_lock_max = 22        frames of forced steering after wall jump
```

**Combat:**

```
nail_damage = 1
nail_cd_max = 18     frames between swings (~0.3s at 60fps)
nail_dur_max = 20    frames nail swing animation shows
nail_hitbox_dur = 8  frames hitbox stays active (tighter than animation)
nail_bounce_force = -13  upward bounce when nailing downward onto enemy
```

**Soul:**

```
soul_max = 99
soul_current = 0
soul_per_hit = 11   soul gained per nail hit (9 hits fills the bar)
```

**Spell:**

```
soul_cost_vs = 11   soul cost to cast Vengeful Spirit (1/9 of max)
spell_cd_max = 30   frames between casts (~0.5s)
cast_dur_max = 18   frames knight is frozen during cast
```

**Health:**

```
health_max = 5
health_current = 5
i_frames_max = 60  invincibility frames after being hit (1 second)
```

**Death:**

```
dead = false
death_dur = 90    frames before respawn (1.5 seconds)
spawn_x / spawn_y  saved at creation, used for respawn position
room_current       saved at creation, used with transition_to() on death
```

#### Step

Processes every frame in this order:

**1. Input reading**
Checks both keyboard and gamepad. Gamepad takes priority if connected. All movement is blocked (`key_left = false` etc.) during `casting`. This is the Hollow Knight cast freeze - the knight can't move while casting.

**2. Collision state**

```gml
on_ground     = place_meeting(x, y+1, oPhysicalObject)
on_wall_left  = place_meeting(x-1, y, oPhysicalObject) && !on_ground
on_wall_right = place_meeting(x+1, y, oPhysicalObject) && !on_ground
```

Walls are only counted if airborne - ground contact overrides wall contact.

**3. Horizontal movement**

Three modes:

- `wall_jump_lock > 0`: Knight has just wall-jumped. Input weakly influences speed via `approach()` but lock decays each frame, gradually returning control.
- `_clinging` (touching a wall while falling): Only input pressing INTO the wall does anything. Pressing away does nothing - the jump code handles wall departure.
- Normal: If moving, set `hsp = move_speed * direction` (ground - instant) or nudge with `accel_air` (air - gradual). If not moving, set 0 (ground) or bleed via `friction_air` (air).

**4. Jump buffer**
Jump buffer counts down every frame. Pressing jump resets it to `jump_buffer_max` (6). This means: if you press jump up to 6 frames before landing, the jump still fires when you land. This is distinct from coyote time (which is time after walking off a ledge).

**5. Jumping**

- **Ground jump**: If `jump_buffer > 0 && can_jump`. Sets `vsp = jump_force`, fires downward dust particles.
- **Wall jump**: If `jump_buffer > 0 && on_wall && !on_ground`. Sets `vsp = wall_jump_vsp`, `hsp = ±wall_jump_hsp`, fires directional wall particles, locks steering.
- **Variable jump height**: If jump is released early and knight is still rising (`vsp < -2`), add 0.6 upward friction each frame. Short taps = short hop. Hold = full jump.

**6. Gravity and fast fall**

Base gravity `gravity_val = 0.5`. Three modifiers:

- Descending: gravity × 1.4 (falls faster than it rises - asymmetric arc)
- Wall sliding: gravity × 0.4, max fall = `wall_slide_speed` (slow drift)
- Fast fall: gravity + `fast_fall_speed`, max fall = `fast_fall_max`

**7. Nail cooldown timers**
Counts down `nail_cooldown`, `nail_duration`. Deactivates `nail_active` when `nail_duration` expires.

**8. Spell cooldown + cast timer**
If `casting`, counts down `cast_timer`. At 0: `casting = false`, spawns `oVengefulSpirit`.

**9. Spell input**
If `key_spell` pressed with enough soul and not on cooldown: deduct soul, start casting, spawn cast particles, trigger soul flash.
If not enough soul: flash the vessel red.

**10. Nail input**
If `key_nail` pressed with no cooldown:

- Determine direction (up, down, or horizontal based on which direction keys are held and whether airborne)
- Destroy any existing nail hitbox for this knight
- Calculate hitbox position based on direction and reach offsets
- Spawn `oNailHitbox` with correct sprite, damage, owner

**11. I-frames**
Counts down `i_frames` each frame.

**12. Collision resolution**
Horizontal first, then vertical. Slide along walls by using `sign(hsp)` steps. Captures `vsp_prev` before collision to detect landing impacts.

**13. Landing dust**
If just landed (`on_ground && !was_on_ground && vsp_prev > 2`), spawn ground impact particles.

**14. Enemy body collision**
Pushes knight out of enemy hitbox by 2px in the opposite direction.

**15. Walk dust**
Increments `walk_particle_timer`. Every `walk_particle_rate` frames while grounded and moving, spawn a small dust particle slightly left-of-up.

**16. Death**

Two phases:

- `health_current <= 0 && !dead`: Begin death. Set `dead = true`, zero velocity, burst white particles, screenshake, call `transition_to(room_current)`.
- `dead == true`: Count down `death_timer`. At 0: restore health/soul/position, set `dead = false`, give i-frames, call `transition_to(room_current)` again (fade back in).

**17. Camera**
Smooth follow with lerp factor 0.15. Clamped to room bounds.

#### Draw

1. `draw_self()` - draws the sprite
2. White rectangle flash overlay when `hit_flash > 0` (hit feedback)
3. Blue rectangle nail visualization when `nail_active` (debug-style nail art)
4. Purple pulse glow around knight when `casting`

---

### `oPhysicalObject`

**Purpose:** Parent object for all solid geometry (floor tiles, wall tiles, platforms). Has no events of its own. Every tile layer or object that should block movement should be a child of this or use this as a collision target.

All collision checks in the project use `place_meeting(x, y, oPhysicalObject)` - because of parent-child inheritance, any child object is included in these checks automatically.

---

### `oEnemy` (parent)

**Purpose:** Base class for all enemies. Provides shared variables and the Take Hit event. Children (`oCrawler`, `oLeaper`) inherit from this via `event_inherited()`.

**Events:**

#### Create

```gml
enemy_health = 3
hsp = 0; vsp = 0
hit_flash = 0   // countdown for white flash on hit
i_frames = 0    // brief period after hitting player where they can't hit again
```

#### Step

Two things:

1. Apply gravity and vertical collision resolution (same pattern as the knight)
2. Contact damage: If touching `oKnight` and knight isn't i-framing, deal 1 damage to knight, give them knockback and i-frames, spawn red particles, screenshake(5)

#### Draw

Draws the sprite, then overlays a white rectangle when `hit_flash > 0`.

#### User Event 0 (Other_10) - Take Hit

Called by `oNailHitbox` and `oVengefulSpirit` via `event_user(0)`:

1. If already dead (`enemy_health <= 0`), exit early (prevents double-death)
2. Decrement `enemy_health`, start `hit_flash`
3. If `enemy_health <= 0`: burst red particles, screenshake(4), destroy

---

### `oCrawler`

**Purpose:** A simple patrol enemy that walks back and forth. Turns at walls and ledges. Inherits from `oEnemy`.

**Events:**

#### Create

```gml
event_inherited();    // runs oEnemy Create
enemy_health = 2      // dies in 2 hits
hsp = 1.5             // starts moving right
wall_check_dist = 1   // pixels ahead to detect wall
ledge_check_dist = 8  // pixels ahead at ground level to detect ledge
```

#### Step

The Crawler overrides the parent Step entirely (doesn't call `event_inherited()`):

1. Gravity + vertical collision (same as oEnemy)
2. Patrol AI:
   - Get current direction: `_dir = sign(hsp)`
   - Wall check: `place_meeting(x + wall_check_dist * _dir, y, oPhysicalObject)` → if true, flip `hsp`
   - Ledge check: `!place_meeting(x + ledge_check_dist * _dir, y + 1, oPhysicalObject)` → if no floor ahead, flip `hsp`
   - Apply `x += hsp`
   - `image_xscale = sign(hsp)` to face direction
3. Contact damage (same as oEnemy - copied, not inherited)
4. Hit flash countdown

---

### `oLeaper`

**Purpose:** An enemy that stands still, detects the knight within a range, then leaps toward them. Has a cooldown between leaps. Inherits from `oEnemy`.

**Events:**

#### Create

```gml
event_inherited();
enemy_health  = 3
detect_range  = 150   // pixel radius to notice knight
leap_force_h  = 4     // horizontal speed on leap
leap_force_v  = -9    // vertical speed on leap (upward)
leap_cd_max   = 120   // frames between leaps (2 seconds)
leaping = false
on_ground = false
```

#### Step

1. Gravity + full collision (horizontal and vertical, since it leaps)
2. Air friction: `hsp = lerp(hsp, 0, 0.05)` when airborne
3. Leap AI:
   - Count down `leap_cooldown`
   - If on ground, not currently leaping, knight within `detect_range`, and cooldown expired: leap toward knight
   - On landing after leap: reset `leaping = false`, spawn landing particles
4. Always faces the knight with `image_xscale = sign(knight.x - x)`
5. Contact damage (same as oEnemy - copied)
6. Hit flash countdown

---

### `oNailHitbox`

**Purpose:** An invisible hitbox spawned by `oKnight` each time it swings the nail. Lasts `nail_hitbox_dur` frames, checks for overlap with enemies and breakables, then destroys itself.

**Events:**

#### Create

```gml
owner     = noone   // set to oKnight id by spawner
swing_dir = 0       // 0=right, 1=left, 2=up, 3=down
lifetime  = 0       // frames left (set by spawner)
damage    = 1
hit_list  = []      // array of enemy ids already hit this swing
```

#### Step

Each frame:

1. Count down lifetime. Destroy on 0.
2. Destroy if owner no longer exists.
3. For every `oEnemy` instance, manual bbox overlap check:
   - Skip if enemy is in `hit_list` (already hit this swing)
   - Check: `(hx1 < ex2) && (hx2 > ex1) && (hy1 < ey2) && (hy2 > ey1)`
   - On hit:
     - Add enemy to `hit_list`
     - Add soul to knight (`soul_per_hit = 11`)
     - If soul just became full for the first time: burst purple particles + flash vessel
     - Apply recoil to knight: down-nail = nail bounce upward; other directions = slight horizontal/vertical pushback
     - Spawn yellow impact particles, screenshake(3)
     - Call `event_user(0)` on the enemy (Take Hit)
4. For every `oBreakable`, same bbox check:
   - Spawn impact particles, screenshake(2)
   - Call `event_user(0)` on the breakable (Take Hit)

**Why manual bbox instead of `place_meeting`?** Because the hitbox is positioned at an offset from the knight, and `place_meeting` doesn't easily give overlap info from inside a `with` block against a different object. Direct bbox math is explicit and reliable.

---

### `oVengefulSpirit`

**Purpose:** The Vengeful Spirit spell - a fireball that travels horizontally, damages enemies and breakables, and destroys itself on wall collision or timeout.

**Events:**

#### Create

```gml
owner    = noone    // set by knight on spawn
hsp      = 8        // set by knight (positive=right, negative=left)
facing   = 1
lifetime = 180      // 3 seconds at 60fps
damage   = 1
hit_list = []       // enemies already hit (for multi-hit prevention)
color = make_color_rgb(200, 150, 255)  // purple
size  = 12
```

#### Step

Each frame:

1. Count down `lifetime`. On expiry: poof particles, destroy.
2. Check wall collision ahead. On hit: poof particles, destroy.
3. Move: `x += hsp`
4. Trail: every 2 frames, spawn a small fading purple particle
5. Hit check against `oEnemy` - same manual bbox as nail hitbox. On hit: particles, screenshake, fire `event_user(0)` on enemy, then destroy the spirit.
6. Hit check against `oBreakable` - same pattern.

#### Draw

Two rectangles at `x, y`:

- Outer glow: `color` at 30% alpha, full `size`
- Inner core: `c_navy` at 100% alpha, 50% of `size`

---

### `oBreakable`

**Purpose:** A destructible crate. On being hit, checks a global config table and spawns the appropriate pickups.

**Events:**

#### Create

```gml
enemy_health  = 1       // one hit to break
hit_flash     = 0
hit_flash_max = 8
breakable_type = "crate_soul"  // overridden in room Creation Code
```

#### Draw

Draws sprite, then white overlay on `hit_flash > 0`.

#### User Event 0 - Take Hit

Called by nail and Vengeful Spirit:

1. If already destroyed, exit
2. Decrement health, start flash
3. If dead:
   - Spawn brown wood-chip particles
   - screenshake(3)
   - Look up `breakable_type` in `global.breakable_types`
   - For each drop in the config, spawn the corresponding orb (`oSoulOrb` or `oHealthOrb`) with random spread velocity
   - Destroy self

**Adding new crate types:** Edit `init_breakable_types()` in `scr_init.gml`. The `type` field of each drop entry must be `"soul"` or `"health"` (these are the only two orb types).

---

### `oSoulOrb`

**Purpose:** A pickup that restores soul. Has a settle phase (falls after being spawned), a bobbing idle animation, and a magnetic attract phase when the knight gets close.

**Events:**

#### Create

```gml
sprite_scale  = 0.4     // render size multiplier
hsp = 0; vsp = 0
bob_timer     = random(360)  // randomized offset so orbs don't sync-bob
bob_speed     = 0.06
bob_amount    = 4       // pixels of vertical bob
attract_range = 60      // pixels - triggers fly-to-player
attract_speed = 6       // speed while flying to player
soul_value    = 33      // soul restored on collection
settled       = false
gravity_val   = 0.3
```

#### Step

Three phases:

1. **Unsettled**: Falls with gravity, collision-resolves against floor, sets `settled = true` on landing. Uses `hsp` for pop spread that bleeds off.
2. **Settled, idle**: Increments `bob_timer` each frame. Y offset is calculated in Draw only - the actual position doesn't change.
3. **Attracted**: When knight is within `attract_range`, fly toward them using `point_direction` + `lengthdir_x/y`. Collect (give soul, particles, destroy) when distance < 12px.

#### Draw

Calculates `_bob_y` from `sin(bob_timer)` and draws the sprite at `y + _bob_y` at `sprite_scale`. Also has a commented-out glow circle if you want to add it.

---

### `oHealthOrb`

**Purpose:** Identical in structure to `oSoulOrb` but restores 1 health instead of soul, uses `spr_health_orb`, and has a red flash on the UI instead of purple.

Collection logic:

```gml
if health_current < health_max {
    health_current++;
    // flash health color on UI
}
```

Does not heal if already at max health.

---

## 6. Phase Breakdown - What Was Built When

Based on commit history, the project was built across these phases:

---

### Phase 1 - Core Movement

**What was built:**

- `oKnight` Create + Step: horizontal movement, jump, gravity, wall slide
- `oPhysicalObject` as collision parent
- Manual collision resolution (pixel-step while loop pattern)
- `scr_approach` utility function
- Basic camera follow

**Key decisions made:**

- No built-in GMS physics - custom gravity and movement for full control
- `move_speed = 4` with instant ground acceleration - same feel as Hollow Knight
- `accel_air = 0.2` - heavy committed air movement (you can't stop mid-air quickly)

---

### Phase 2 - Combat

**What was built:**

- `oNailHitbox` - directional hitbox with hit list
- `oEnemy` parent - health, hit flash, contact damage
- `oCrawler` - patrol AI
- Soul system variables on `oKnight`
- Nail direction logic (up/down/horizontal)

---

### Phase 3 - Soul System + Vengeful Spirit

**What was built:**

- Soul gained per nail hit (`soul_per_hit = 11`)
- Soul cost for spells (`soul_cost_vs = 11`)
- Cast freeze (`casting = true`, `cast_dur_max = 18`)
- `oVengefulSpirit` - projectile with trail particles
- `obj_soul_ui` - health masks + soul vessel bar
- Soul flash feedback (white on cast, red on failure)

---

### Phase 4 - Camera + Screenshake

**What was built:**

- Camera smooth-follow with lerp 0.15
- `screenshake()` function in `scr_particles`
- `obj_soul_ui` Draw_72 applies shake offset to camera after GUI draw
- Shake decay per frame

---

### Phase 5 + 6 - Particles, Polish, Breakables, Collectibles

**What was built:**

- `obj_particle` - single-instance particle system
- `spawn_particles()` and `spawn_particles_directional()` in `scr_particles`
- All particle spawn calls: jump dust, wall jump, landing, walk dust, hit impacts, spell effects, soul full burst
- `oBreakable` - destructible crates
- `scr_init` - `init_breakable_types()` for configurable drop tables
- `oSoulOrb` + `oHealthOrb` - pickups with settle/bob/attract behavior
- `oLeaper` - leaping enemy AI

---

### Phase 7 - Menu System + Transitions

**What was built:**

- `obj_transition` - persistent fade overlay
- `transition_to()` helper function
- `obj_menu` - full title screen with Controls and Options sub-screens
- `rm_menu` room
- Death + respawn using `transition_to(room_current)`

---

### Phase 8 (most recent commit) - Death/Respawn + Parallax

**What was built:**

- `dead` flag and `death_timer` on `oKnight`
- Full death → respawn flow: burst particles → screenshake → fade out → reload room → fade in → restore state
- `spawn_x` / `spawn_y` stored at knight creation for respawn position
- `obj_parallax` - procedural scrolling background with depth layers

---

## 7. Tuning Reference - Every Configurable Variable

This section is for when you want to change how the game feels. Change one variable at a time and playtest.

---

### Player Movement Feel

| Variable          | Location       | Default | Effect                                                                                                                      |
| ----------------- | -------------- | ------- | --------------------------------------------------------------------------------------------------------------------------- |
| `move_speed`      | oKnight Create | `4`     | Max horizontal speed. Higher = faster. Hollow Knight used ~3-4 at similar scale.                                            |
| `accel_ground`    | oKnight Create | `4`     | Ground acceleration. Equals `move_speed` = instant ground stop/start. Reduce for ice-like friction.                         |
| `accel_air`       | oKnight Create | `0.2`   | Air acceleration per frame. Lower = more committed mid-air (heavier feel). 0.2 is very HK. Try 0.5 for more responsive air. |
| `friction_air`    | oKnight Create | `0.85`  | Multiplied on `hsp` when no horizontal input in air. Lower = carries momentum longer.                                       |
| `fast_fall_speed` | oKnight Create | `0.8`   | Extra gravity added when holding down in air. Higher = snappier fast fall.                                                  |
| `fast_fall_max`   | oKnight Create | `18`    | Terminal velocity during fast fall.                                                                                         |

---

### Jump Arc

| Variable                            | Location       | Default | Effect                                                                                  |
| ----------------------------------- | -------------- | ------- | --------------------------------------------------------------------------------------- |
| `jump_force`                        | oKnight Create | `-11`   | Initial upward velocity on jump. More negative = higher jump.                           |
| `gravity_val`                       | oKnight Create | `0.5`   | Gravity added per frame. Higher = snappier arc.                                         |
| `max_fall_speed`                    | oKnight Create | `14`    | Terminal velocity (normal). Higher = faster falls.                                      |
| `jump_buffer_max`                   | oKnight Create | `6`     | Frames a buffered jump is valid. 6 = very forgiving. 0 = disabled.                      |
| Variable jump `0.6`                 | oKnight Step   | `0.6`   | Friction added to upward velocity when jump released. Higher = more short-hop variance. |
| Descending gravity multiplier `1.4` | oKnight Step   | `1.4`   | Gravity multiplier when falling. 1.0 = symmetric arc. 1.4 = HK-style fast fall.         |

---

### Wall Jump

| Variable             | Location       | Default | Effect                                                                               |
| -------------------- | -------------- | ------- | ------------------------------------------------------------------------------------ |
| `wall_slide_speed`   | oKnight Create | `2`     | Max fall speed while wall-sliding. Lower = slower slide. 0 = perfect wall cling.     |
| `wall_jump_hsp`      | oKnight Create | `5`     | Horizontal force on wall jump. Higher = shoots out further.                          |
| `wall_jump_vsp`      | oKnight Create | `-10`   | Vertical force on wall jump. More negative = higher.                                 |
| `wall_jump_lock_max` | oKnight Create | `22`    | Frames of reduced steering after wall jump. Higher = more committed to the jump arc. |

---

### Combat Timing

| Variable                        | Location       | Default | Effect                                                                       |
| ------------------------------- | -------------- | ------- | ---------------------------------------------------------------------------- |
| `nail_cd_max`                   | oKnight Create | `18`    | Frames between nail swings (~0.3s). Lower = faster attack rate.              |
| `nail_hitbox_dur`               | oKnight Create | `8`     | Frames hitbox stays active. Lower = tighter timing window.                   |
| `nail_dur_max`                  | oKnight Create | `20`    | Frames nail visual shows. Can be longer than hitbox.                         |
| `nail_damage`                   | oKnight Create | `1`     | Damage per swing.                                                            |
| `nail_bounce_force`             | oKnight Create | `-13`   | Upward velocity when nailing down onto enemy. More negative = higher bounce. |
| `nail_reach` `_reach`           | oKnight Step   | `20`    | Pixels ahead nail hitbox spawns. Higher = longer reach.                      |
| `nail_reach_down` `_reach_down` | oKnight Step   | `32`    | Downward nail reach (bigger for downsweep).                                  |

---

### Soul System

| Variable       | Location       | Default | Effect                                                                               |
| -------------- | -------------- | ------- | ------------------------------------------------------------------------------------ |
| `soul_max`     | oKnight Create | `99`    | Max soul. Keep at 99 - soul_per_hit and soul_cost are tuned to this.                 |
| `soul_per_hit` | oKnight Create | `11`    | Soul gained per nail hit. 11 = 9 hits to fill. Change in tandem with `soul_cost_vs`. |
| `soul_cost_vs` | oKnight Create | `11`    | Soul cost for Vengeful Spirit. At 11 cost and 11 per hit, 1 hit = 1 cast potential.  |

---

### Spells

| Variable                   | Location               | Default | Effect                                                      |
| -------------------------- | ---------------------- | ------- | ----------------------------------------------------------- |
| `spell_cd_max`             | oKnight Create         | `30`    | Frames between casts (~0.5s). Lower = spam casting.         |
| `cast_dur_max`             | oKnight Create         | `18`    | Frames knight is frozen while casting. 0 = no freeze.       |
| `oVengefulSpirit hsp`      | oVengefulSpirit Create | `8`     | Projectile speed (set by knight). Higher = faster fireball. |
| `oVengefulSpirit lifetime` | oVengefulSpirit Create | `180`   | Frames before auto-expire (~3s).                            |

---

### Health and Damage

| Variable                 | Location        | Default | Effect                                                          |
| ------------------------ | --------------- | ------- | --------------------------------------------------------------- |
| `health_max`             | oKnight Create  | `5`     | Number of health masks.                                         |
| `i_frames_max`           | oKnight Create  | `60`    | Invincibility frames after hit (1 second). Lower = harder game. |
| `enemy_health` (Crawler) | oCrawler Create | `2`     | Hits to kill crawler.                                           |
| `enemy_health` (Leaper)  | oLeaper Create  | `3`     | Hits to kill leaper.                                            |

---

### Screen Shake

| Variable               | Location           | Default | Effect                                                                      |
| ---------------------- | ------------------ | ------- | --------------------------------------------------------------------------- |
| `shake_decay`          | obj_soul_ui Create | `0.75`  | Multiplied each frame. 0.75 = shake lasts ~10 frames. 0.9 = lingers longer. |
| `shake_min`            | obj_soul_ui Create | `0.5`   | Shake snaps to 0 below this. Prevents micro-vibration.                      |
| Nail hit intensity     | oNailHitbox Step   | `3`     | `screenshake(3)` - light.                                                   |
| Player hit intensity   | oEnemy Step        | `5`     | `screenshake(5)` - medium.                                                  |
| Player death intensity | oKnight Step       | `8`     | `screenshake(8)` - heavy.                                                   |
| Breakable hit          | oNailHitbox Step   | `2`     | Lightest shake.                                                             |

---

### Particle Tuning

| Variable                  | Location            | Default         | Effect                                                  |
| ------------------------- | ------------------- | --------------- | ------------------------------------------------------- |
| `jump_particle_count`     | oKnight Create      | `8`             | Particles on jump.                                      |
| `jump_particle_color`     | oKnight Create      | `rgb(80,80,80)` | Jump dust color.                                        |
| `walk_particle_rate`      | oKnight Create      | `8`             | Frames between walk dust spawns. Lower = more frequent. |
| `wall_particle_count`     | oKnight Create      | `6`             | Particles on wall jump.                                 |
| `obj_particle friction`   | obj_particle Create | `0.85`          | How fast particles slow. Lower = more slide.            |
| `obj_particle fade_speed` | obj_particle Create | `0.06`          | How fast particles fade. Higher = shorter lived.        |

---

### Enemy AI

| Variable           | Location        | Default | Effect                              |
| ------------------ | --------------- | ------- | ----------------------------------- |
| `hsp` (Crawler)    | oCrawler Create | `1.5`   | Patrol speed.                       |
| `wall_check_dist`  | oCrawler Create | `1`     | How close to a wall before turning. |
| `ledge_check_dist` | oCrawler Create | `8`     | How far ahead to check for ledges.  |
| `detect_range`     | oLeaper Create  | `150`   | Pixel range to notice knight.       |
| `leap_force_h`     | oLeaper Create  | `4`     | Horizontal speed of leap.           |
| `leap_force_v`     | oLeaper Create  | `-9`    | Vertical force of leap.             |
| `leap_cd_max`      | oLeaper Create  | `120`   | Frames between leaps (2s).          |

---

### Collectibles

| Variable        | Location          | Default | Effect                                    |
| --------------- | ----------------- | ------- | ----------------------------------------- |
| `soul_value`    | oSoulOrb Create   | `33`    | Soul restored per orb.                    |
| `health_value`  | oHealthOrb Create | `1`     | Health restored per orb.                  |
| `attract_range` | Orbs Create       | `60`    | Distance at which orbs fly toward knight. |
| `attract_speed` | Orbs Create       | `6`     | Speed while flying to knight.             |
| `bob_amount`    | Orbs Create       | `4`     | Pixels of vertical bob oscillation.       |
| `sprite_scale`  | Orbs Create       | `0.4`   | Render scale (0.4 = 40% of sprite size).  |

---

### Transitions

| Variable     | Location              | Default | Effect                                                                            |
| ------------ | --------------------- | ------- | --------------------------------------------------------------------------------- |
| `fade_speed` | obj_transition Create | `0.04`  | Opacity change per frame. 0.04 = ~25 frames per transition. Higher = faster fade. |

---

### Parallax

| Layer index | Speed | Description                             |
| ----------- | ----- | --------------------------------------- |
| 0           | 0.0   | Solid black background fill             |
| 1           | 0.15  | Far layer - barely moves                |
| 2           | 0.30  | Mid layer                               |
| 3           | 0.50  | Near layer - moves at half camera speed |

Add more layers to the `layers` array in `obj_parallax` Create. Higher `rects` = busier layer.

---

## 8. How Systems Talk to Each Other

This section maps out the dependencies - which objects reference which.

```
obj_init
  └─ calls init_breakable_types() → populates global.breakable_types
     └─ used by oBreakable User Event 0

obj_transition (persistent singleton)
  └─ transition_to(room_id) sets it in motion
     ├─ called by obj_menu (on START)
     ├─ called by oKnight (on death, on respawn)
     └─ called by scr_init.transition_to()

oKnight
  ├─ reads obj_soul_ui.shake_intensity → sets it via screenshake()
  ├─ reads obj_soul_ui.soul_flash → sets it on cast
  ├─ spawns oNailHitbox → oNailHitbox.owner = oKnight.id
  ├─ spawns oVengefulSpirit → oVengefulSpirit.owner = oKnight.id
  └─ modifies its own: hsp, vsp, soul_current, health_current, i_frames

oNailHitbox
  ├─ reads oKnight via owner ref → modifies soul_current, vsp/hsp (recoil)
  ├─ calls event_user(0) on oEnemy → triggers Take Hit
  ├─ calls event_user(0) on oBreakable → triggers Take Hit
  └─ reads/writes obj_soul_ui.soul_flash

oVengefulSpirit
  ├─ calls event_user(0) on oEnemy → triggers Take Hit
  └─ calls event_user(0) on oBreakable → triggers Take Hit

oEnemy (parent), oCrawler, oLeaper
  └─ modify oKnight.health_current, i_frames, hsp, vsp on contact

oBreakable
  └─ spawns oSoulOrb / oHealthOrb on death (from global.breakable_types config)

oSoulOrb
  └─ modifies oKnight.soul_current on collection

oHealthOrb
  ├─ modifies oKnight.health_current on collection
  └─ reads/writes obj_soul_ui.soul_flash

obj_soul_ui
  ├─ reads oKnight.health_current, health_max, soul_current, soul_max
  └─ applies shake_x/shake_y to camera in Draw_72

screenshake() (script function)
  └─ writes obj_soul_ui.shake_intensity
```

---

## 9. Rooms

### `rm_menu`

The first room. Contains:

- `obj_init` - initializes global data (persistent, fires once)
- `obj_transition` - fade overlay (persistent)
- `obj_menu` - the title screen

Room Creation Code:

```gml
display_set_gui_size(1280, 720);
```

### `rm_test`

The gameplay room. Contains:

- `oKnight` - the player
- `obj_parallax` - scrolling background
- `obj_soul_ui` - HUD
- Tile layers for the level geometry (children of `oPhysicalObject`)
- Enemy instances (`oCrawler`, `oLeaper`)
- Breakable instances - two with Creation Code overriding `breakable_type = "crate_mixed"`
- A `Particles` layer - used as the target layer for all particle spawns

**Room layers (by name):**

- `Background` - parallax obj
- `Tiles` - solid tile geometry (uses `oPhysicalObject` as collision)
- `Instances` - main gameplay objects
- `Particles` - particle objects (kept separate so particles draw on top)
- `UI` - HUD objects

---

## 10. Porting to a New Project

If you want to use this codebase as a base for a new game, here is the exact checklist:

---

### Step 1 - Copy the core files

These are required for the system to function:

**Scripts (all of them):**

- `scr_approach` - utility math
- `scr_init` - global init + transition helper
- `scr_particles` - particle spawn + screenshake

**Core objects:**

- `obj_init` - must be placed in your first room
- `obj_transition` - must be placed in your first room
- `obj_particle` - required for all particle effects
- `obj_soul_ui` - required for screenshake (even if you don't show HUD)
- `oKnight` - player

**Collision:**

- `oPhysicalObject` - parent for all solid objects

**Optional but already built:**

- `obj_menu` - main menu (rebrand/reskin)
- `obj_parallax` - background
- `oEnemy`, `oCrawler`, `oLeaper` - enemies
- `oNailHitbox`, `oVengefulSpirit` - combat
- `oBreakable`, `oSoulOrb`, `oHealthOrb` - pickups

---

### Step 2 - Sprites

The code references these sprites by name. Either recreate them or rename your own:

- `spr_knight` - player sprite (origin should be bottom-center)
- `spr_crawler` - crawler enemy
- `spr_leaper` - leaper enemy
- `spr_soul_orb` - soul pickup
- `spr_health_orb` - health pickup
- `spr_nail_h` - horizontal nail hitbox (can be invisible - 1×1 white pixel)
- `spr_nail_v` - vertical nail hitbox (can be invisible)

**Sprite origins matter:** The knight's Y position is the bottom of the sprite. `sprite_height` is used to offset things like the spell spawn point and nail hitbox.

---

### Step 3 - Font

`fnt_dialogue` is referenced in `obj_menu`. Create this font in your new project (or rename the reference) - any monospaced pixel font works.

---

### Step 4 - Room setup

Each room needs:

1. A `Particles` layer (string name matters - spawn functions use layer name `"Particles"`)
2. A `Tiles` layer with your solid geometry parented to `oPhysicalObject`
3. An `Instances` layer for gameplay objects
4. `obj_soul_ui` placed in the room
5. `oKnight` placed in the room

In the first room only:

- Place `obj_init`
- Place `obj_transition`

---

### Step 5 - Update `transition_to()` targets

In `obj_menu` Step, the START case calls:

```gml
transition_to(rm_test);
```

Change `rm_test` to your first gameplay room.

---

### Step 6 - Update `display_set_gui_size`

Called in two places:

- `rm_menu` Room Creation Code
- `oKnight` Create

Both set `1280, 720`. Change to match your target resolution if different.

---

### Step 7 - Update camera resolution

In `oKnight` Create:

```gml
camera_set_view_size(_cam, 480, 270);
```

This is your internal render resolution. `480×270` is 16:9 at a pixel-art friendly scale. Change if your game uses a different resolution.

---

### Step 8 - Breakable drop table

In `scr_init`, `init_breakable_types()` defines what crates drop. Add new types here for your game. The type string set in room Creation Code (`breakable_type = "..."`) must match a key in this struct.

---

### Step 9 - Remove placeholder art

The knight and enemies draw as sprites, but there is also debug/placeholder rendering:

- The nail in `oKnight` Draw is drawn as a **blue rectangle** - replace with a sprite animation
- The Vengeful Spirit in `oVengefulSpirit` Draw is drawn as **rectangles** - replace with a sprite
- The soul orb and health orb **glow circles** are commented out - uncomment or replace with a proper glow sprite

---

### Step 10 - Add animations

The codebase has no animation state machine. All objects use `draw_self()` with a single static sprite. To add animations:

1. Add an `anim_state` variable in Create
2. Set the sprite and image_speed in Step based on state (`on_ground`, `hsp`, `nail_active`, etc.)
3. Use `sprite_index = spr_knight_run` etc.

The knight's `image_xscale = facing` already handles sprite flipping - animation integration just needs to change `sprite_index`.

---

_This document covers the full Bug Knight prototype as of the Phase 8 commit (2025-05). Every system is documented to the level where you can rebuild it, modify it, or port it without needing to read the source code directly._
