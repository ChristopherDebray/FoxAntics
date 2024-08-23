extends Area2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var sprite_2d: Sprite2D = $Sprite2D

const TRIGGER_CONDITION = "parameters/conditions/on_trigger"

func _ready() -> void:
	SignalManager.on_boss_killed.connect(on_boss_killed)

func on_boss_killed(_points: int) -> void:
	sprite_2d.visible = true
	animation_tree[TRIGGER_CONDITION] = true
	# Allows to listen colisions
	monitoring = true
	SoundManager.play_clip(sound, SoundManager.SOUND_CHECKPOINT)

func _on_area_entered(_area: Area2D) -> void:
	SoundManager.play_clip(sound, SoundManager.SOUND_WIN)
	SignalManager.on_level_completed.emit()
