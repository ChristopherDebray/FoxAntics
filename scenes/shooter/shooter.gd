extends Node2D

class_name Shooter

@onready var shoot_timer: Timer = $ShootTimer
@onready var sound: AudioStreamPlayer2D = $Sound

@export var speed: float = 50.00
@export var life_span: float = 10.00
@export var bullet_key: Constants.ObjectType
@export var shoot_delay	: float = 0.70

var _can_shoot: bool = true

func _ready() -> void:
	shoot_timer.wait_time = shoot_delay

func _process(delta: float) -> void:
	pass

func shoot(dir: Vector2) -> void:
	if _can_shoot == false:
		return
	
	_can_shoot = false
	SignalManager.on_create_bullet.emit(
		global_position,
		dir,
		life_span,
		speed,
		bullet_key
	)
	
	shoot_timer.start()
	SoundManager.play_clip(sound, SoundManager.SOUND_LASER)

func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
