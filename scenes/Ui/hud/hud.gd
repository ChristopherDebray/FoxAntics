extends Control

@onready var life_container: HBoxContainer = $MarginContainer/HBoxContainer/LifeContainer
@onready var color_rect: ColorRect = $ColorRect
@onready var vb_level_complete: VBoxContainer = $ColorRect/VBLevelComplete
@onready var vb_game_over: VBoxContainer = $ColorRect/VBGameOver
@onready var points_label: Label = $MarginContainer/HBoxContainer/PointsLabel
@onready var sound: AudioStreamPlayer = $Sound
@onready var continue_timer: Timer = $ContinueTimer

var _hearts: Array[Node]
var _can_continue: bool = false

func _ready() -> void:
	on_score_updated(ScoreManager.get_score())
	_hearts = life_container.get_children()
	SignalManager.on_player_hit.connect(set_displayed_lives)
	SignalManager.on_level_started.connect(set_displayed_lives)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_score_updated.connect(on_score_updated)
	SignalManager.on_level_completed.connect(on_level_completed)

func _process(_delta: float) -> void:
	if _can_continue == true && Input.is_action_just_pressed("jump"):
		if vb_game_over.visible:
			GameManager.load_main_scene()
		else:
			GameManager.load_next_level_scene()

func set_displayed_lives(lives: int) -> void:
	for life in range(_hearts.size()):
		_hearts[life].visible = lives > life

func show_hud() -> void:
	color_rect.show()

func on_score_updated(points: int) -> void:
	points_label.text = "%03d" % points

func on_game_over() -> void:
	show_hud()
	vb_game_over.show()
	sound.play()
	continue_timer.start()

func on_level_completed() -> void:
	show_hud()
	vb_level_complete.show()
	continue_timer.start()

func _on_continue_timer_timeout() -> void:
	_can_continue = true
