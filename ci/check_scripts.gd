extends SceneTree
## CI / local helper: loads every .gd script in the project and exits non-zero if any fail to
## compile. This is the same check the maintainer runs by hand, automated for pull requests.
##
## Usage (run a one-time import first so preloaded scenes resolve on a fresh checkout):
##     godot --headless --import
##     godot --headless --path . -s ci/check_scripts.gd
##
## load()-ing a script compiles it with the project's autoloads registered, so references to
## Refs/Settings resolve correctly (unlike `--check-only` on a single file in isolation).

func _initialize() -> void:
	var failed: PackedStringArray = []
	var total := _scan("res://", failed)
	print("Checked %d script(s)." % total)
	if failed.is_empty():
		print("OK: all scripts compiled.")
		quit(0)
	else:
		printerr("FAILED: %d script(s) did not compile:" % failed.size())
		for f in failed:
			printerr("  - ", f)
		quit(1)

## Recursively loads every .gd under [param path], appending any that fail to [param failed].
## Returns the number of scripts checked. Skips hidden dirs (.godot, .git) and this ci/ folder.
func _scan(path: String, failed: PackedStringArray) -> int:
	var count := 0
	var dir := DirAccess.open(path)
	if dir == null:
		return 0
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		var full := path.path_join(entry)
		if dir.current_is_dir():
			if not entry.begins_with(".") and entry != "ci":
				count += _scan(full, failed)
		elif entry.ends_with(".gd"):
			count += 1
			var res = load(full)
			if not (res is GDScript) or not res.can_instantiate():
				failed.append(full)
		entry = dir.get_next()
	dir.list_dir_end()
	return count
