extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer

const HIGH_SCORE_LABEL = preload("res://scenes/high_score_label/high_score_label.tscn")

func _ready() -> void:
	clear_scores()
	set_scores()

func set_scores() -> void:
	for score in ScoreManager.get_score():
		var label: Label = HIGH_SCORE_LABEL.instantiate()
		label.text = "%04d" % score
		grid_container.add_child(label)

func clear_scores() -> void:
	for score in grid_container.get_children():
		grid_container.remove_child(score)
