extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var direction_timer = $DirectionTimer
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var shooter: Shooter = $Shooter

const FLY_SPEED: Vector2 = Vector2(35, 15)

var _fly_direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	super._physics_process(delta)
	velocity = _fly_direction
	move_and_slide()
	
	if player_detector.is_colliding():
		shooter.shoot(Vector2.DOWN)
		

func set_and_flip() -> void:
	var x_dir = sign(_player_ref.global_position.x - global_position.x)
	if x_dir > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	_fly_direction = Vector2(x_dir, 1) * FLY_SPEED

func fly_to_player() -> void:
	set_and_flip()
	direction_timer.start()

func _on_screen_entered():
	animated_sprite_2d.play("fly")
	fly_to_player()

func _on_direction_timer_timeout():
	fly_to_player()
