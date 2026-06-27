# Contributing to Stellar Highway

Thanks for taking an interest! Stellar Highway is an open-source passion project, and contributions — bug fixes, new obstacles, new characters, polish, docs — are very welcome.

Before anything else, please read the developer's two asks (also in the [README](README.md#a-note-from-the-developer)):

- **Don't add gambling systems or lootboxes** if you build on this.
- A **mention or a link back** to this repo is appreciated if the code/assets help you.

By contributing, you agree your changes are licensed under the project's **GPLv3** (see [`LICENSE`](LICENSE)).

---

## Getting set up

1. Install **Godot 4.5.1 (stable)** — standard (non-.NET) build. [Download archive](https://godotengine.org/download/archive/4.5.1-stable/).
2. Import this folder's [`project.godot`](project.godot) from the Godot project manager.
3. Press **F5** to play. The entry scene is [`Intro.tscn`](Intro.tscn).

The [README](README.md#architecture-overview) has the full architecture tour — read it first. The short version:

- **One script per node.** Scripts in `GameFiles/Gameplay Scripts/` are attached to nodes in scenes under `GameFiles/Sprites/` (and the three `GameFiles/Modes/` scenes).
- **Two autoloads:** [`Refs`](GameFiles/Gameplay%20Scripts/Refs.gd) (shared constants + cached node lookups + `Refs.shake()`) and [`Settings`](GameFiles/Gameplay%20Scripts/Settings.gd) (persisted prefs).
- **Objects find each other via Godot groups** (see the README's "Groups" table), not hard references.
- The world is sized at a fixed **1080 px height**; spawners offset by `true_scalex / true_scaley` (from the `Playfield`/`sizeChange` node) so things appear just off the right edge on any aspect ratio.

---

## How to add content

### A new obstacle
1. Make a scene in `GameFiles/Sprites/Obstacles/…` and a script in `GameFiles/Gameplay Scripts/Obstacles/…`. Use an existing simple one as a template — [`Airships.gd`](GameFiles/Gameplay%20Scripts/Obstacles/Airships.gd) or a [`Building`](GameFiles/Gameplay%20Scripts/Obstacles/Buildings/Building1.gd) are good starts.
2. Expose an **`offx`** value — how far past its own origin the player must travel before it's safe to despawn. The generators use it to recycle.
3. Make deadly sides kill the player with an `Area2D` that calls `body.tartar_sauce()` (see [`killPlayer.gd`](GameFiles/Gameplay%20Scripts/killPlayer.gd)), and lay [`Star`](GameFiles/Sprites/Currency/Star.tscn) instances along the *safe* path (players follow the stars).
4. Register it in [`ObstacleGenerator.gd`](GameFiles/Gameplay%20Scripts/ObstacleGenerator.gd): add the scene to the `objs` array and include its index in the simple-spawn `match` arms. (Obstacles higher in the list appear later, as the spawn pool grows with distance.)
5. Optionally add a heads-up warning via [`indicatorManager.gd`](GameFiles/Gameplay%20Scripts/Indicators/indicatorManager.gd).

### A new powerup
1. Scene in `GameFiles/Sprites/Powerups/…`, script in `GameFiles/Gameplay Scripts/Powerups/…` — copy an existing one like [`Umbrella.gd`](GameFiles/Gameplay%20Scripts/Powerups/Umbrella.gd).
2. On pickup, change the player's state, show a HUD icon via the `PowerupPopUps` group, and `reparent` to the player so it rides along.
3. Add it to the building powerup spawn lists (e.g. [`Restaurant1.gd`](GameFiles/Gameplay%20Scripts/Obstacles/Buildings/Restaurant1.gd)) and the `PowerupPopUps` slot indices.

### A new character
Characters are sprites under the player's `Characters` node, selected by index in [`player_physics.gd`](GameFiles/Gameplay%20Scripts/player_physics.gd) `_ready()` and priced in [`characterSelector.gd`](GameFiles/Gameplay%20Scripts/characterSelector.gd).

---

## Conventions

- **Match the surrounding code.** The codebase has a playful, informal style (some function names are jokes — see the README's "Glossary of Odd Names"). That's fine; don't reformat the whole file or rename things just for style.
- **Document new scripts** with a `##` doc comment at the top (and on non-obvious methods) — that's the project's standard and it shows up in Godot's built-in help.
- **Prefer `Refs`/`Settings` and groups** over deep `../../../` node paths where practical.
- **No multithreaded gameplay code** (keep logic single-threaded and easy to follow).

---

## Testing your change

- **Play it.** Most things — drawing, rolling, obstacles — can only really be judged by playing a run in the editor.
- **Run the script-compile check** before opening a PR:
  ```
  godot --headless --import
  godot --headless --path . -s ci/check_scripts.gd
  ```
  This loads every script and fails if any don't compile. CI runs the same check on every push/PR (see [`.github/workflows/ci.yml`](.github/workflows/ci.yml)).

---

## Pull requests

- Keep PRs focused — one feature/fix per PR.
- Describe what you changed and how you tested it (which mode(s) you played).
- Make sure the compile check passes.

Thanks again — and don't forget to [grab the game](https://play.google.com/store/apps/details?id=org.stellarstones.sh)! 🎸
