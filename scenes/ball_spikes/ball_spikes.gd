extends PathFollow2D

@export var speed: float = 0.2

func _process(delta: float) -> void:
	progress_ratio = progress_ratio + delta * speed
