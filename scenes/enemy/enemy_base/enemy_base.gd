extends CharacterBody2D

class_name EnemyBase

enum FACING { LEFT = -1, RIGHT = 1 }

const OFF_SCREEN_KILL_ME: float = 1000.0

@export var default_facing: FACING = FACING.LEFT
# Points earned on kill
@export var points: int = 1
@export var _speed: float = 30.0

var _gravity: float = 900.0
var _facing: FACING = default_facing
var _player_ref: Player
var _dying: bool = false

func _ready():
	_player_ref = get_tree().get_nodes_in_group(GameManager.GROUP_PLAYER)[0]

func _physics_process(delta):
	fallen_off()

func fallen_off() -> void:
	if global_position.y > OFF_SCREEN_KILL_ME:
		queue_free()

func die():
	if _dying == true:
		return
	
	SignalManager.on_create_object.emit(
		global_position,
		Constants.ObjectType.EXPLOSION
	)
	SignalManager.on_create_object.emit(
		global_position,
		Constants.ObjectType.PICKUP
	)
	_dying = true
	SignalManager.on_enemy_hit.emit(points)
	set_physics_process(false)
	hide()
	queue_free()

func flip_character(sprite: AnimatedSprite2D):
	sprite.flip_h = !sprite.flip_h 
	if _facing == FACING.LEFT:
		_facing = FACING.RIGHT
	else:
		_facing = FACING.LEFT

func _on_screen_entered():
	pass # Replace with function body.

func _on_screen_exited():
	pass # Replace with function body.

func _on_hit_box_area_entered(area: Area2D) -> void:
	die()
