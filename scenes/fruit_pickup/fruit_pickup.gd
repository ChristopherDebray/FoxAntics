extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY: float = 160.0
const JUMP: float = -120.0
const points: int = 2

var _start_y: float
var _speed_y: float = JUMP

func _ready() -> void:
	_start_y = position.y
	var anim_name_list = Array(anim.sprite_frames.get_animation_names())
	anim.animation = anim_name_list.pick_random()
	anim.play()

func _process(delta: float) -> void:
	position.y += _speed_y * delta
	_speed_y += GRAVITY * delta
	
	if position.y > _start_y:
		set_process(false)

func die() -> void:
	hide()
	queue_free()


func _on_life_timer_timeout() -> void:
	die()


func _on_fruit_pickup(_area: Area2D) -> void:
	SignalManager.on_pickup_hit.emit(points)
	die()
