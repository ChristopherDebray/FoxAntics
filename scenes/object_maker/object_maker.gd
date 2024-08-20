extends Node2D

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://scenes/bullet_base/bullet_player.tscn"),
	Constants.ObjectType.BULLET_ENEMY: preload("res://scenes/bullet_base/bullet_enemy.tscn"),
	Constants.ObjectType.EXPLOSION: preload("res://scenes/explosion/explosion.tscn"),
	Constants.ObjectType.PICKUP: preload("res://scenes/fruit_pickup/fruit_pickup.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_create_bullet.connect(on_create_bullet)
	SignalManager.on_create_object.connect(on_create_object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_create_bullet(
	pos: Vector2,
	dir: Vector2,
	life_span: float,
	speed: float,
	ob_type: Constants.ObjectType,
):
	if !OBJECT_SCENES.has(ob_type):
		return
	
	var bullet: Bullet = OBJECT_SCENES[ob_type].instantiate()
	bullet.setup(
		pos,
		dir,
		speed,
		life_span
	)
	call_deferred("add_child", bullet)

func on_create_object(pos: Vector2, ob_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES.has(ob_type):
		return
	
	var object = OBJECT_SCENES[ob_type].instantiate()
	object.position = pos
	call_deferred("add_child", object)
