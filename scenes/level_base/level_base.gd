extends Node2D

@export var camera_max: Vector2
@export var camera_min: Vector2

@onready var player = $Player

func _ready():
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_level_completed.connect(on_level_completed)
	player.set_camera_limits(camera_max, camera_min)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance"):
		GameManager.load_next_level_scene()
	if Input.is_action_just_pressed("quit"):
		GameManager.load_main_scene()

func stop_game():
	var moveables = get_tree().get_nodes_in_group(Constants.MOVEABLES_GROUP)
	for moveable in moveables:
		moveable.set_process(false)
		moveable.set_physics_process(false)

func on_game_over() -> void:
	stop_game()

func on_level_completed() -> void:
	stop_game()
	
