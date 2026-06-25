# Stellar Highway

**Stellar Highway** is a 2D endless runner for Android, built in the [Godot Engine](https://godotengine.org/) and released on the Google Play Store. This repository is the game's **full, open-source codebase**, released under the GPLv3.

> 📱 **Play it:** [Stellar Highway on Google Play](https://play.google.com/store/apps/details?id=org.stellarstones.sh)

Stellar Highway is a passion project that wasn't built to make money, so as a big fan of open source and a believer in the GPL, it was only right to release the game open source. It is the first video game I (Safwan Murad) ever made — so the code isn't always the cleanest, but it all works, and this README + the in-code comments should help you find your way around.

---

## Table of Contents

- [The Game](#the-game)
- [How It Plays](#how-it-plays)
- [Controls](#controls)
- [Building & Running](#building--running)
- [Project Layout](#project-layout)
- [Architecture Overview](#architecture-overview)
  - [Boot & Scene Flow](#boot--scene-flow)
  - [Anatomy of a Game Mode](#anatomy-of-a-game-mode)
  - [The Player & Physics](#the-player--physics)
  - [Drawing the Track](#drawing-the-track)
  - [Spawning the World](#spawning-the-world)
  - [Resolution Scaling](#resolution-scaling)
  - [Saving & Progression](#saving--progression)
  - [The "Groups" Wiring](#the-groups-wiring)
- [Code Map](#code-map)
- [Glossary of Odd Names](#glossary-of-odd-names)
- [A Note From the Developer](#a-note-from-the-developer)
- [Credits](#credits)
- [License](#license)

---

## The Game

Stellar Highway is an **endless runner with a twist**: instead of jumping over gaps, **you draw the ground**. You trace a line under a constantly rolling character with your finger (or an S Pen, or a mouse), and the character rolls along whatever you draw — up hills to slow down, down hills to speed up — Sonic-the-Hedgehog style. The goal is to survive as long as possible, rack up distance, collect stars, and dodge a city's worth of hazards.

The game ships with **three game modes**:

| Mode | Scene | What happens |
| --- | --- | --- |
| **Endless Runner** | `GameFiles/Modes/EndlessRunnerMode.tscn` | The classic mode. Roll across a procedurally assembled skyline of buildings, dragons, airships, missiles and more. Score = distance travelled + stars collected. |
| **Hole-in-a-Wall** | `GameFiles/Modes/HoleIn-a-WallMode.tscn` | "Wall-o-Bats." Walls made of bats fly toward you, each with a single gap. Draw a path through the gap. The walls get tighter and faster over time. |
| **Missiles** | `GameFiles/Modes/MissilesMode.tscn` | A wave-based survival mode. Homing and timed missiles chase you from all sides. Survive each wave to score. Lock-on missiles can be detonated by steering them into a line you draw. |

---

## How It Plays

- **Draw to survive.** Your drawn line is real, solid terrain (a physics collider). Keep a line under the character or it falls off the bottom of the screen and it's game over.
- **Momentum matters.** The character keeps the speed it builds. Going downhill accelerates, uphill decelerates. You can even *roll backwards* if you understand the momentum — useful for retiming tricky obstacles.
- **Stars** are the currency. Collect them mid-run; spend them in the menu's shop to unlock new playable characters.
- **Powerups** sit on certain rooftops. There are several (Jetpack, Umbrella, Lowrider, Doppelgänger, Rockstar Guitar) and each changes how you play. Some double as a one-time "second chance" — getting hit while you hold a defensive powerup consumes it and grants a few seconds of invincibility instead of ending the run.
- **Buildings are walkable on top** but deadly from the side — hit a wall head-on and you lose. Indicators ("danger" arrows and beeps) warn you of upcoming hazards. *When in doubt, follow the stars* — they're laid along the safe path.

The full in-game tutorial text lives in [`GameFiles/Gameplay Scripts/tutorialBook.gd`](GameFiles/Gameplay%20Scripts/tutorialBook.gd) and is the most player-facing description of every obstacle.

---

## Controls

The game is designed for touch, but it has full keyboard support (handy for testing in the editor):

**In a run**
- **Touch / drag / mouse drag** — draw terrain under the character.
- **Spacebar / Enter** (`ui_accept`) — bounce/jump (only while the **Lowrider** powerup is active; there's also an on-screen bounce button).
- **P** — pause / resume.
- **M** — mute / unmute.

**In the main menu**
- **1 / 2 / 3** — pick Endless / Hole-in-a-Wall / Missiles.
- **1–6** — select a character (in the character row).
- **S** — open / close the shop.
- **Enter** — start the selected mode.
- **← / →** — flip tutorial pages; **Esc** — close popups.

---

## Building & Running

This is a standard Godot project — there is no separate build step to just play it.

1. Install **Godot 4.5.1 (stable)**. Grab it from the [Godot archive](https://godotengine.org/download/archive/4.5.1-stable/). The project uses the **Mobile** renderer and no C#, so the standard (non-.NET) build is all you need.
2. Open the Godot project manager → **Import** → select this folder's [`project.godot`](project.godot).
3. Press **F5** (or the ▶ button) to run. The main scene is [`Intro.tscn`](Intro.tscn).

**Exporting to Android** uses Godot's standard Android export pipeline. The app id is `org.stellarstones.sh`; export configuration lives in [`export_presets.cfg`](export_presets.cfg). You'll need the Android SDK/JDK and a debug/release keystore configured in the Godot editor's export settings. Note that the `/android/` build template folder is **git-ignored** — Godot regenerates it via *Project → Install Android Build Template*.

---

## Project Layout

```
Stellar-Highway/
├── project.godot              # Godot project config (entry scene, display, rendering)
├── Intro.tscn                 # Boot scene: studio intro video → MainMenu
├── MainMenu.tscn              # Main menu: mode select, character shop, tutorial, settings
├── icon.png                   # App icon
├── export_presets.cfg         # Android export configuration
├── LICENSE                    # GPLv3
└── GameFiles/
    ├── Modes/                 # The three playable game-mode scenes
    ├── Gameplay Scripts/      # Almost all game logic (player, obstacles, powerups, UI…)
    │   ├── CharacterScripts/  #   Per-character helper scripts
    │   ├── Currency/          #   Stars (the in-game currency) + counters
    │   ├── Indicators/        #   "Danger" warnings for upcoming hazards
    │   ├── Obstacles/         #   Every hazard (buildings, dragons, missiles, bats…)
    │   ├── Powerups/          #   Jetpack, Umbrella, Lowrider, Doppelgänger, Rockstar…
    │   └── States/            #   Player state machine states (on ground / in air)
    ├── ScreenView Scripts/    # Camera/UI/menu visual helpers (not core gameplay)
    ├── Sprites/               # Scene (.tscn) files for every object, instanced at runtime
    ├── SpinHead IMGS/         # Source PNG art ("SpinHead" was the project's working title)
    ├── OST/ & SoundEffects/   # Music (.mp3) and sound effects
    ├── Assets/                # Fonts (Press Start 2P) and the black-&-white shader
    └── Intro/                 # Intro video assets
```

A few conventions to keep in mind while reading the source:

- **One script per node.** Almost every script `extends` a Godot node type and is attached directly to a node in a scene. Some nodes exist *only* to host a script (a manager or generator with no visuals).
- **Scripts in `Gameplay Scripts/` ↔ scenes in `Sprites/`.** A script like `Obstacles/Dragon.gd` is the brain attached to the scene `Sprites/Obstacles/Dragon/Dragon.tscn`. Generators `preload` and `instantiate` these `.tscn` files.
- **No autoloads / singletons.** Cross-object communication happens almost entirely through **Godot groups** (see [The "Groups" Wiring](#the-groups-wiring)) and relative node paths.
- **No multithreaded gameplay code.** (`project.godot` enables physics on a separate thread, but the game logic itself is single-threaded and easy to follow.)

---

## Architecture Overview

### Boot & Scene Flow

```
Intro.tscn ──(studio video + jingle finishes)──▶ MainMenu.tscn ──(pick mode, press start)──▶ <Mode>.tscn
   sts_intro.gd                                      menuOST.gd                                  gameStarter.gd waits for first touch
```

- [`Intro.tscn`](Intro.tscn) / [`sts_intro.gd`](GameFiles/Gameplay%20Scripts/sts_intro.gd) — plays the studio intro video, then switches to the main menu. Also installs the Android back-button / window-close handling used throughout the game.
- [`MainMenu.tscn`](MainMenu.tscn) — its root node runs [`menuOST.gd`](GameFiles/Gameplay%20Scripts/menuOST.gd) (menu music + quit handling). The menu hosts the mode picker ([`Gamemodes.gd`](GameFiles/Gameplay%20Scripts/Gamemodes.gd)), the character shop ([`characterSelector.gd`](GameFiles/Gameplay%20Scripts/characterSelector.gd), [`shopBTN.gd`](GameFiles/Gameplay%20Scripts/shopBTN.gd)), the tutorial book, the settings panel, and the "press to start" clapperboard ([`ScreenView Scripts/MainMenu/gameStart.gd`](GameFiles/ScreenView%20Scripts/MainMenu/gameStart.gd)) that loads the chosen mode.
- The chosen **mode scene** loads behind a loading animation. [`gameStarter.gd`](GameFiles/Gameplay%20Scripts/gameStarter.gd) holds the run frozen until your **first touch**, then kicks off the spawners and the player's minimum speed.

### Anatomy of a Game Mode

All three mode scenes share the same skeleton. Using Endless Runner as the example:

```
EndlessRunnerMode (Node2D)            ← root; OST script picks music & sets the gamemode index
├── Utils (Node2D)                    ← save/load (Utils.gd)
├── sizeChange (Node2D)               ← "Playfield" group; aspect-ratio scaling (changeSize.gd)
│   ├── BG                            ← parallax-ish background
│   ├── Player (CharacterBody2D)      ← the playable character (player_physics.gd + state machine)
│   ├── SpeedLine (Line2D)            ← the speed trail behind the player
│   ├── Building1 (StaticBody2D)      ← the fixed starting platform
│   ├── ObstacleGenerator (Node2D)    ← spawns/recycles obstacles ahead of the player
│   ├── indicatorManager (Node2D)     ← spawns danger warnings
│   ├── spdManager (Node2D)           ← ramps the player's minimum speed up over distance
│   ├── NOPE / BarrierBuilding        ← invisible guards (ceiling + "don't fall behind" wall)
│   └── LightProjector(s)             ← decorative spotlights
├── playerInput (Node2D)              ← turns touches into solid drawn lines (playerInput.gd)
└── UI (CanvasLayer)
    ├── Score / Stars / Speed labels
    ├── PowerupTXT + powerup icons    ← the "PowerupPopUps" group
    ├── pause / replay / quit / mute buttons
    ├── ClipperBoard                  ← the game-over clapperboard (gameOverClipper.gd)
    └── Loading                       ← the load-in / load-out animation
```

Hole-in-a-Wall swaps `ObstacleGenerator` for [`WallGenManager`](GameFiles/Gameplay%20Scripts/WallGenManager.gd); Missiles swaps it for [`MissileGenManager`](GameFiles/Gameplay%20Scripts/MissileGenManager.gd) and a `GetThemOut` node that slides the starting platform away once the fight begins.

### The Player & Physics

The character's movement is **Sonic-style momentum physics**, adapted from [marmitoTH's Godot Sonic Physics](https://github.com/marmitoTH/Godot-Sonic-Physics). The implementation is split across four scripts:

- [`player_physics.gd`](GameFiles/Gameplay%20Scripts/player_physics.gd) (`class_name PlayerPhysics`, a `CharacterBody2D`) — the core. It tracks **ground speed (`gsp`)**, the current **ground mode** (floor / wall / ceiling quadrant), and uses four `RayCast2D` "sensors" (two for the ground, two for walls) to follow slopes. On top of the base physics it layers all the *game* concerns: which character is selected and rendered, the trail colour, star-collection sound, the doppelgänger clone syncing, powerup bookkeeping, and the damage/game-over flow.
- [`state_machine.gd`](GameFiles/Gameplay%20Scripts/state_machine.gd) + [`state.gd`](GameFiles/Gameplay%20Scripts/state.gd) — a tiny two-state machine. Each physics frame it calls `host.physics_step()` (sensor updates) then the active state's `step()`, which may request a transition.
- [`States/on_ground.gd`](GameFiles/Gameplay%20Scripts/States/on_ground.gd) — rolling along terrain: applies slope acceleration, friction, the speed cap, wall stops, and jumping; falls to `OnAir` when there's no ground.
- [`States/on_air.gd`](GameFiles/Gameplay%20Scripts/States/on_air.gd) — airborne: applies gravity (scaled by the Umbrella powerup), air drag and Jetpack thrust; returns to `OnGround` on landing.

The damage path is worth knowing by name: **`tartar_sauce()`** is the "you got hit" handler. If you're holding a defensive powerup it's consumed for ~4 seconds of invincibility (`invisFrames`); otherwise **`doTheGameoverThing()`** saves your stars + high score, pauses the tree, and shows the clapperboard.

The **Doppelgänger** powerup spawns a second body using the [`PlayerSUS.tscn`](GameFiles/Sprites/PlayerSUS.tscn) scene (also `player_physics.gd`, but named `PlayerSUS`). It mirrors the real player and absorbs one hit. The same physics script branches on `name == "Player"` to tell the real player from a clone.

### Drawing the Track

[`playerInput.gd`](GameFiles/Gameplay%20Scripts/playerInput.gd) converts pointer input into terrain. As your finger moves, it samples points in world space and, every ~15 px, instantiates a [`CollLine.tscn`](GameFiles/Sprites/CollLine.tscn) segment — a `StaticBody2D` carrying a `Line2D` (the visible stroke) and a `SegmentShape2D` (the collider the character actually rolls on). It supports **touch, S Pen, and mouse** input (the S Pen reports as mouse events on Android). When the **Rockstar** powerup is active, stars are sprinkled along the drawn line. Each segment fades itself out after a few seconds (or once the player passes it) via [`CollLine.gd`](GameFiles/Gameplay%20Scripts/CollLine.gd) to keep memory in check.

### Spawning the World

The world ahead of the player is generated and recycled by one manager per mode:

- [`ObstacleGenerator.gd`](GameFiles/Gameplay%20Scripts/ObstacleGenerator.gd) (Endless) — keeps a single obstacle on screen at a time. It picks an obstacle by random index (the pool of allowed obstacles *grows* with distance for a difficulty curve), positions it ahead of the player scaled by the current aspect ratio, and frees it once the player has passed. Dragons and missile groups have bespoke multi-spawn logic.
- [`WallGenManager.gd`](GameFiles/Gameplay%20Scripts/WallGenManager.gd) (Hole-in-a-Wall) — spawns bat walls whose gap tightens and difficulty rises with each wall.
- [`MissileGenManager.gd`](GameFiles/Gameplay%20Scripts/MissileGenManager.gd) (Missiles) — an `await`-driven wave loop: announce "Wave N", spawn `N×2` missiles from random edges, wait, award score/stars, repeat.

Each obstacle scene exposes an `offx` value (how far past its own origin the player must travel before it's safe to despawn), which the generators use to recycle cleanly.

### Resolution Scaling

The game renders at a fixed **1080 px height**, but the width is flexible to fit any phone. [`changeSize.gd`](GameFiles/ScreenView%20Scripts/changeSize.gd) (on the `sizeChange` node, in the `Playfield` group) watches the window size and computes `true_scalex` / `true_scaley`. Spawners multiply their horizontal offsets by `true_scalex / true_scaley` so obstacles appear just off the right edge regardless of the device's aspect ratio, and the camera offset is adjusted to match.

### Saving & Progression

[`Utils.gd`](GameFiles/Gameplay%20Scripts/Utils.gd) (on the `Utils` node) owns persistence. Two JSON files are written under Godot's `user://` directory:

- `savefile.bin` — `{ "playerCharacter": int, "Stars": int, "ownedChars": [6 bools] }`
- `scorefile.bin` — `{ "0": int, "1": int, "2": int }` — the high score for each of the three modes.

There are **6 characters** (indices 0–5). Character 0 is free; the rest cost `[15000, 20000, 25000, 30000, 35000]` stars and are bought in the shop ([`characterSelector.gd`](GameFiles/Gameplay%20Scripts/characterSelector.gd)).

### The "Groups" Wiring

With no autoloads, objects find each other through **Godot groups**. The most important ones:

| Group | Who's in it | Looked up for… |
| --- | --- | --- |
| `Player` | the playable character | everything player-related |
| `Playfield` | the `sizeChange` node | the scaling factors + the world parent to add children to |
| `Utils` | the save/load node | reading/writing the save files |
| `playerInput` | the drawing node | pausing/clearing the drawn line |
| `Score` / `Stars` / `StarCnt` | the HUD labels | reading & adding to score and stars |
| `PowerupPopUps` | the powerup HUD nodes | `[0]` is the text label, `[1]`–`[5]` are the powerup icons (Rockstar, Jetpack, Doppelgänger, Umbrella, Lowrider) |
| `pauseman` / `clipperBoy` | pause button / game-over board | pausing and showing the game-over screen |
| `Missiles` / `TMissiles` / `GMissiles` | live missiles | targeting markers & on-screen arrows |
| `SpeedLine` / `MoreBounce` | speed trail / bounce button | visual effects tied to state |

When you see `get_tree().get_first_node_in_group("…")` in the code, this table is the key to what it's reaching for.

---

## Code Map

A system-by-system index of the scripts under `GameFiles/`. Each file also carries a `##` doc comment at the top explaining itself in detail.

**Core loop & player**
- [`main.gd`](GameFiles/Gameplay%20Scripts/main.gd) — small standalone helper (hides cursor, F11 fullscreen). *Not currently attached to a scene.*
- [`player_physics.gd`](GameFiles/Gameplay%20Scripts/player_physics.gd), [`state_machine.gd`](GameFiles/Gameplay%20Scripts/state_machine.gd), [`state.gd`](GameFiles/Gameplay%20Scripts/state.gd), [`States/on_ground.gd`](GameFiles/Gameplay%20Scripts/States/on_ground.gd), [`States/on_air.gd`](GameFiles/Gameplay%20Scripts/States/on_air.gd) — player & physics.
- [`playerInput.gd`](GameFiles/Gameplay%20Scripts/playerInput.gd), [`CollLine.gd`](GameFiles/Gameplay%20Scripts/CollLine.gd) — terrain drawing.
- [`jump_btn.gd`](GameFiles/Gameplay%20Scripts/jump_btn.gd) — on-screen bounce button.

**World generation & flow**
- [`ObstacleGenerator.gd`](GameFiles/Gameplay%20Scripts/ObstacleGenerator.gd), [`WallGenManager.gd`](GameFiles/Gameplay%20Scripts/WallGenManager.gd), [`MissileGenManager.gd`](GameFiles/Gameplay%20Scripts/MissileGenManager.gd), [`DragonsGenerator.gd`](GameFiles/Gameplay%20Scripts/DragonsGenerator.gd) — spawners.
- [`gameStarter.gd`](GameFiles/Gameplay%20Scripts/gameStarter.gd), [`spdManager.gd`](GameFiles/Gameplay%20Scripts/spdManager.gd), [`GetThemOut.gd`](GameFiles/Gameplay%20Scripts/GetThemOut.gd) — run start & speed ramp.
- [`NOPE.gd`](GameFiles/Gameplay%20Scripts/NOPE.gd), [`Barrier.gd`](GameFiles/Gameplay%20Scripts/Barrier.gd), [`killPlayer.gd`](GameFiles/Gameplay%20Scripts/killPlayer.gd), [`MaskSetter.gd`](GameFiles/Gameplay%20Scripts/MaskSetter.gd) — invisible guards & collision-layer switching.
- [`EndlessRunnerModeOST.gd`](GameFiles/Gameplay%20Scripts/EndlessRunnerModeOST.gd) — mode root: picks music, sets the gamemode index.

**Persistence, score & currency**
- [`Utils.gd`](GameFiles/Gameplay%20Scripts/Utils.gd) — save/load.
- [`Score.gd`](GameFiles/Gameplay%20Scripts/Score.gd), [`ScoreMissiles.gd`](GameFiles/Gameplay%20Scripts/ScoreMissiles.gd), [`Speed.gd`](GameFiles/Gameplay%20Scripts/Speed.gd) — HUD readouts.
- [`Currency/Star.gd`](GameFiles/Gameplay%20Scripts/Currency/Star.gd), [`Currency/StarCounter.gd`](GameFiles/Gameplay%20Scripts/Currency/StarCounter.gd), [`Currency/menuStars.gd`](GameFiles/Gameplay%20Scripts/Currency/menuStars.gd) — stars.

**Menus & UI**
- [`Gamemodes.gd`](GameFiles/Gameplay%20Scripts/Gamemodes.gd), [`characterSelector.gd`](GameFiles/Gameplay%20Scripts/characterSelector.gd), [`shopBTN.gd`](GameFiles/Gameplay%20Scripts/shopBTN.gd), [`tutorialBook.gd`](GameFiles/Gameplay%20Scripts/tutorialBook.gd), [`settingsMenu.gd`](GameFiles/Gameplay%20Scripts/settingsMenu.gd), [`menuOST.gd`](GameFiles/Gameplay%20Scripts/menuOST.gd) — main-menu screens.
- [`pause.gd`](GameFiles/Gameplay%20Scripts/pause.gd), [`mute.gd`](GameFiles/Gameplay%20Scripts/mute.gd), [`gameOverClipper.gd`](GameFiles/Gameplay%20Scripts/gameOverClipper.gd) — in-run UI.
- [`ScreenView Scripts/`](GameFiles/ScreenView%20Scripts) — visual helpers: `Loading.gd`, `SpeedLine.gd`, `Glow.gd`, `rotateLight.gd`, `changeSize.gd`, `MainMenu/gameStart.gd`, `MainMenu/spawnDoppel.gd`, `UI/p2s.gd`.

**Obstacles** — [`Obstacles/`](GameFiles/Gameplay%20Scripts/Obstacles): buildings (`Building1-3`, `Restaurant1`, `RandomBuilding`/`RandomBuilding2`, `UnderConstruction`+`HeavyPendulum`, `TurPro`+`TurBlades` wind turbines), `Hotel`, `Airships`, `Dragon`/`MenuDragon`, `Bat`/`WallBat`/`BatWall`, `StudioStuff`/`HangingStudioStuff`, and `Missile`/`Fuse4Missile`/`MissileMark`/`TMissileMark`. `Move.gd` is a shared "drift horizontally" helper.

**Powerups** — [`Powerups/`](GameFiles/Gameplay%20Scripts/Powerups): `Jetpack`, `Umbrella`, `Lowrider`, `Doppelgänger`, `RockstarGuitar`, `SpeedBooster`, plus `FireLine` (jetpack trail) and `PowerupPopUps`/`PowerupPopUpsSP` (HUD markers).

**Indicators** — [`Indicators/`](GameFiles/Gameplay%20Scripts/Indicators): `indicatorManager` plus per-hazard warnings (`airshipsInd`, `dragonsInd`, `hangingInd`, `hotelInd`) and the missile markers (`MissileMarkerManager`).

---

## Glossary of Odd Names

This was a first project, and some names are… playful. The meanings (now also in the code comments):

| Name | What it actually is |
| --- | --- |
| `tartar_sauce()` | The player's "took a hit" handler (damage → invincibility or game over). |
| `doTheGameoverThing()` | Commits the game over: saves, pauses, shows the clapperboard. |
| `NOPE` | An invisible ceiling guard that stops the player flying off the top. |
| `PlayerSUS` / `da_sus` / `imposter` | The Doppelgänger clone of the player ("sus" = Among Us joke). |
| `killMe4FreeRAM()` | A drawn line freeing itself to reclaim memory. |
| `giveBirth()` / `giveAnotherBirth()` | Append a collision segment to a procedural building's outline. |
| `myCondolences()` | Show the game-over screen. |
| `snitch()` | Point a danger arrow at the missile it's tracking. |
| `pleaseStopHesAlreadyDead` | Flag that a missile has already exploded (ignore further hits). |
| `ScrewConstantStrings` | A cached array of window textures (avoids re-`preload`ing). |
| `getUrS___Right()` | Re-positions the tutorial book's page buttons. |
| `SpinHead` (in asset paths) | The project's working title; it's all over the art folders. |

---

## A Note From the Developer

The game's code is under the GPL, so you're free to do what you like with it, but as the developer I'd just ask:

- If you use this as a template, **please don't build gambling systems or lootboxes** as microtransactions. (I can't stop you — but please don't.)
- If the code or assets help you, a **mention of me or a link to this repository** would be sincerely appreciated.
- Please don't just re-release the game unchanged.
- And if you want to support me, just **download the game from the Google Play Store** lmao.

---

## Credits

**Character Physics** — by marmitoTH (Lucas Rodrigues) · https://github.com/marmitoTH/Godot-Sonic-Physics
**Missile Explosion Animation** — by @nyk_nck · https://nyknck.itch.io/explosion
**Game Design, Music, Trailer & Basically Everything Else** — by Safwan Murad

---

## License

Stellar Highway is released under the **GNU General Public License v3.0**. See [`LICENSE`](LICENSE) for the full text.

Thank you for checking out the Stellar Highway open-source repository — and don't forget to [download the game](https://play.google.com/store/apps/details?id=org.stellarstones.sh) if you haven't!
