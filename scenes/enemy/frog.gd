extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_timer = $JumpTimer

const JUMP_VELOCITY: Vector2 = Vector2(120, -170)
const JUMP_WAIT_RANGE: Vector2 = Vector2(2.5, 5)

var _jump: bool = false
# The frog will only start to jump if it has seen the player once
var _has_seen_player: bool = false

func _ready():
	super._ready()
	_start_jump_timer()

func _physics_process(delta):
	super._physics_process(delta)
	
	if is_on_floor() == false:
		velocity.y += _gravity * delta
		animated_sprite_2d.play("jump")
	else:
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	apply_jump()
	move_and_slide()
	flip_frog()

func _start_jump_timer() -> void:
	jump_timer.wait_time = randf_range(JUMP_WAIT_RANGE.x, JUMP_WAIT_RANGE.y)
	jump_timer.start()

func apply_jump():
	if is_on_floor() == false:
		return
	
	if _has_seen_player == false or _jump == false:
		return
	
	velocity = JUMP_VELOCITY
	if animated_sprite_2d.flip_h == false:
		velocity.x = velocity.x * -1
	
	_jump = false
	animated_sprite_2d.play("jump")
	_start_jump_timer()

func flip_frog():
	var is_sprite_h_flipped = animated_sprite_2d.flip_h == true
	var player_x = _player_ref.global_position.x
	if (player_x > global_position.x and !is_sprite_h_flipped):
		animated_sprite_2d.flip_h = true
	elif (player_x < global_position.x and is_sprite_h_flipped):
		animated_sprite_2d.flip_h = false

func _on_jump_timer_timeout():
	_jump = true

func _on_screen_entered():
	_has_seen_player = true
