extends Node2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var visual: Node2D = $Visual

@export var lives: int = 2
@export var points: int = 5

var _is_invicible: bool = false

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

func _reduce_lives() -> void:
	lives -= 1
	if lives <= 0:
		SignalManager.on_boss_killed.emit(points)
		queue_free()

func _take_damage() -> void:
	if _is_invicible == true:
		return
	
	set_is_invicible(true)
	_tween_hit()
	_reduce_lives()

func _tween_hit() -> void:
	var tween = get_tree().create_tween()
	# ZERO is based on the instance base position
	tween.tween_property(visual, "position", Vector2.ZERO, 1.6)

func set_is_invicible(is_invicble: bool) -> void:
	_is_invicible = is_invicble
	if is_invicble == true:
		state_machine.travel("hit")

func _on_hit_box_area_entered(area: Area2D) -> void:
	_take_damage()

func _on_trigger_area_entered(area: Area2D) -> void:
	animation_tree[TRIGGER_CONDITION] = true
