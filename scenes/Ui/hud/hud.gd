extends Control

@onready var life_container: HBoxContainer = $MarginContainer/HBoxContainer/LifeContainer
@onready var color_rect: ColorRect = $ColorRect
@onready var vb_level_complete: VBoxContainer = $ColorRect/VBLevelComplete
@onready var vb_game_over: VBoxContainer = $ColorRect/VBGameOver
@onready var points_label: Label = $MarginContainer/HBoxContainer/PointsLabel

var _hearts: Array[Node]

func _ready() -> void:
	on_score_updated(ScoreManager.get_score())
	_hearts = life_container.get_children()
	SignalManager.on_player_hit.connect(set_displayed_lives)
	SignalManager.on_level_started.connect(set_displayed_lives)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_score_updated.connect(on_score_updated)

func set_displayed_lives(lives: int) -> void:
	for life in range(_hearts.size()):
		_hearts[life].visible = lives > life

func show_lvl_end_layout() -> void:
	color_rect.show()

func on_score_updated(points: int) -> void:
	points_label.text = "%03d" % points

func on_game_over() -> void:
	show_lvl_end_layout()
	vb_game_over.show()
