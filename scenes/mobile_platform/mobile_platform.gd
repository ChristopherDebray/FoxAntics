extends AnimatableBody2D

@export var destination: Marker2D
@export var speed: float = 50.0

var _start: Vector2
var _end: Vector2
var _time_to_move: float = 0.00
var _tween: Tween

func _ready() -> void:
	_start = global_position
	_end = destination.global_position
	
	var distance: float = _start.distance_to(_end)
	_time_to_move = distance / speed
	set_moving()

func set_moving() -> void:
	# Here we set the tween on tree, thing is that if you remove the level base
	# The tween will try to read something that isn't on the tree
	# To fix that we will use the method _exit_tree
	_tween = get_tree().create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "global_position", _end, _time_to_move)
	_tween.tween_property(self, "global_position", _start, _time_to_move)

# This methods overides the default one, runs when the element exit tree
func _exit_tree() -> void:
	if _tween:
		_tween.kill()
