extends Node2D

@onready var player = $Player

func _ready():
	SignalManager.on_game_over.connect(on_game_over)

func on_game_over() -> void:
	var moveables = get_tree().get_nodes_in_group(Constants.MOVEABLES_GROUP)
	for moveable in moveables:
		moveable.set_process(false)
		moveable.set_physics_process(false)
