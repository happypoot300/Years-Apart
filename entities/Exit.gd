extends Area2D

@export var target_level: PackedScene
@export var spawn_position: Vector2

func _ready():
	# Verify signal connection
	if body_entered.is_connected(_on_body_entered):
		print("Exit signal connected properly")
	else:
		push_error("Exit signal not connected!")

func _on_body_entered(body: Node2D):
	print("Body entered exit:", body.name)
	if body.is_in_group("player"):
		print("Transition triggered by player")
		call_deferred("transition_level")

func transition_level():
	print("Attempting to load:", target_level)
	if !target_level:
		push_error("No target level specified in exit!")
		return
	
	if !GameManager:
		push_error("GameManager not found in autoloads")
		return
	
	GameManager.load_level(target_level, spawn_position)
	
