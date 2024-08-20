extends CharacterBody2D

class_name Player

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var sound = $Sound
@onready var shooter: Shooter = $Shooter
@onready var invicible_player: AnimationPlayer = $InviciblePlayer
@onready var invicible_timer: Timer = $InvicibleTimer
@onready var hurt_timer: Timer = $HurtTimer

const FALLEN_OFF: float = 700.0
const GRAVITY: float = 900.00
const RUN_SPEED: float = 120.00
const MAX_FALL: float = 400.00
const HURT_TIME: float = 0.30
const JUMP_VELOCITY: float = -400.00
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0, -130)

enum PLAYER_STATES { IDLE, RUN, FALL, JUMP, HURT }

@export var lives: int = 4
var _player_state = PLAYER_STATES.IDLE
var _is_invicible: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#The player _ready is called before the hud, therefore we must use deffer
	call_deferred("deferred_setup")

func deferred_setup() -> void:
	SignalManager.on_level_started.emit(lives)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	fallen_off()
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calc_state()
	_update_debug_label()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func get_input() -> void:
	# If the player is hurt he won't be able to shoot or anything
	if _player_state == PLAYER_STATES.HURT:
		return
	
	velocity.x = 0
	
	if Input.is_action_pressed("left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	if Input.is_action_pressed("right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false
	if Input.is_action_just_pressed("jump") and is_on_floor() == true:
		velocity.y = JUMP_VELOCITY
		SoundManager.play_clip(sound, SoundManager.SOUND_JUMP)
	
	# Limit the y velocity between y velocity and MAX_FALL
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

func calc_state():
	if _player_state == PLAYER_STATES.HURT:
		return
	
	if is_on_floor() == true:
		if velocity.x == 0:
			set_state(PLAYER_STATES.IDLE)
		else:
			set_state(PLAYER_STATES.RUN)
	else:
		if velocity.y >= 0:
			set_state(PLAYER_STATES.FALL)
		else:
			set_state(PLAYER_STATES.JUMP)

func set_state(state: PLAYER_STATES) -> void:
	if _player_state == state:
		return
	
	var landing_states = [PLAYER_STATES.IDLE, PLAYER_STATES.RUN]
	if _player_state == PLAYER_STATES.FALL:
		if state in landing_states:
			SoundManager.play_clip(sound, SoundManager.SOUND_LAND)
	_player_state = state
	
	match _player_state:
		PLAYER_STATES.IDLE:
			animation_player.play("idle")
		PLAYER_STATES.RUN:
			animation_player.play("run")
		PLAYER_STATES.JUMP:
			animation_player.play("jump")
		PLAYER_STATES.FALL:
			animation_player.play("fall")
		PLAYER_STATES.HURT:
			apply_hurt_jump()

func _update_debug_label() -> void:
	debug_label.text = "lives:%d\nis_inv:%s\non_floor:%s\n%s\n%.0f,%.0f\n\n" % [
		lives,
		_is_invicible,
		is_on_floor(),
		PLAYER_STATES.keys()[_player_state],
		velocity.x,velocity.y,
	]

func shoot() -> void:
	if sprite_2d.flip_h == true:
		shooter.shoot(Vector2.LEFT)
	else:
		shooter.shoot(Vector2.RIGHT) 

func apply_damager() -> void:
	if _is_invicible == true:
		return
	
	set_state(PLAYER_STATES.HURT)
	SoundManager.play_clip(sound, SoundManager.SOUND_DAMAGE)

	if reduce_lives(1) == false:
		return

	go_invicible()

func go_invicible() -> void:
	_is_invicible = true
	invicible_player.play("invicible")
	invicible_timer.start()

func apply_hurt_jump() -> void:
	_player_state = PLAYER_STATES.HURT
	animation_player.play("hurt")
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()

func reduce_lives(damage: int) -> bool:
	lives -= damage
	SignalManager.on_player_hit.emit(lives)
	if lives <= 0:
		SignalManager.on_game_over.emit()
		set_physics_process(false)
		animation_player.stop()
		invicible_player.stop()
		return false
	return true

func fallen_off() -> void:
	if global_position.y < FALLEN_OFF:
		return
	
	reduce_lives(lives)

func _on_hit_box_entered(area):
	apply_damager()

func _on_invicible_timer_timeout() -> void:
	_is_invicible = false
	invicible_player.stop()

func _on_hurt_timer_timeout() -> void:
	set_state(PLAYER_STATES.IDLE)
