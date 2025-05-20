extends CharacterBody2D

const SPEED = 150.0
const FOOTSTEP_INTERVAL = .3  # Adjust this to control sound frequency

@onready var animated_sprite = $AnimatedSprite2D
@onready var sfx_walking: AudioStreamPlayer2D = $SfxWalking

var last_direction := Vector2.DOWN
var time_since_step := 0.0

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var is_moving = input != Vector2.ZERO
	
	handle_movement(input)
	handle_animations(input)
	
	# Simple footstep timing
	if is_moving:
		time_since_step += delta
		if time_since_step >= FOOTSTEP_INTERVAL:
			sfx_walking.play()
			time_since_step = 0.0
	else:
		time_since_step = 0.0
		sfx_walking.stop()

	move_and_slide()

func handle_movement(input: Vector2):
	if input != Vector2.ZERO:
		velocity = input.normalized() * SPEED
		last_direction = Vector2(sign(input.x), sign(input.y))
	else:
		velocity = Vector2.ZERO

func handle_animations(input: Vector2):
	if input != Vector2.ZERO:
		match last_direction:
			Vector2.RIGHT: animated_sprite.play("Walk_Right")
			Vector2.LEFT: animated_sprite.play("Walk_Left")
			Vector2.DOWN: animated_sprite.play("Walk_Down")
			Vector2.UP: animated_sprite.play("Walk_Up")
	else:
		animated_sprite.stop()
		animated_sprite.frame = 0

func _ready():
	add_to_group("player")
	
