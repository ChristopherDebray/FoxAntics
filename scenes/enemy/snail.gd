extends EnemyBase

@onready var floor_detector = $FloorDetector
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	super._physics_process(delta)
	
	if is_on_floor() == false:
		velocity.y += _gravity * delta
	else:
		# facing will be either 1 or -1, so here it also indicates to
		# which direction the element is moving
		velocity.x = _speed * _facing
	
	move_and_slide()
	
	if is_on_wall() == true or floor_detector.is_colliding() == false:
		flip_character(animated_sprite_2d)
		floor_detector.position.x = floor_detector.position.x * -1 
