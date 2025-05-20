extends Node

# Singleton accessible via GameManager (autoload)
var current_spawn_position: Vector2
var player_scene = preload("res://scenes/actors/player.tscn")

func load_level(new_scene: PackedScene, spawn_pos: Vector2):
	print("Loading level: ", new_scene.resource_path)
	print("Spawn position set to: ", spawn_pos)
	
	if not new_scene:
		push_error("Tried to load null scene!")
		return
	
	current_spawn_position = spawn_pos
	
	# Cleanup old scene
	var old_scene = get_tree().current_scene
	if old_scene:
		old_scene.queue_free()
	
	# Load new scene
	var new_level = new_scene.instantiate()
	get_tree().root.add_child(new_level)
	get_tree().current_scene = new_level
	
	# Spawn player
	var player = player_scene.instantiate()
	player.global_position = current_spawn_position
	new_level.add_child(player)
	
	print("Level loaded: ", new_scene.resource_path)

func _ready():
	print("GameManager initialized!")
	spawn_player()  # Add this to spawn immediately

func spawn_player():
	var spawn_point = get_tree().get_first_node_in_group("spawn_point")
	if spawn_point:
		print("Spawn point found at: ", spawn_point.global_position)  # Add this
		var player = preload("res://scenes/actors/player.tscn").instantiate()
		player.global_position = spawn_point.global_position
		get_tree().current_scene.add_child(player)
		print("Player spawned at: ", spawn_point.global_position)
	else:
		push_error("No spawn_point group in initial level!")
		
