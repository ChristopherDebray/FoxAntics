extends Node

const SCORE_FILE: String = "user://FoxyScores.json"
const MAX_SCORES_KEEP = 10

var _score: int = 0
var _scores_history: Array = []

func _ready() -> void:
	SignalManager.on_enemy_hit.connect(update_score)
	SignalManager.on_boss_killed.connect(update_score)
	SignalManager.on_pickup_hit.connect(update_score)
	SignalManager.on_game_over.connect(on_game_over)
	load_scores_history()

func update_score(points: int):
	_score += points
	print("SCORE")
	SignalManager.on_score_updated.emit(_score)

func on_game_over() -> void:
	_scores_history.append({
		"score": _score,
		"date_scored": Time.get_date_string_from_system()
	})
	save_score()

func reset_score() -> void:
	_score = 0

func get_score() -> int:
	return _score

func save_score() -> void:
	_scores_history.sort_custom(compare_scores)
	var file = FileAccess.open(SCORE_FILE, FileAccess.WRITE)
	if file:
		#Saves the last 10 scores into the save file
		file.store_string(JSON.stringify(_scores_history.slice(0, MAX_SCORES_KEEP)))
		file.close()

func load_scores_history():
	_scores_history.clear()
	var file = FileAccess.open(SCORE_FILE, FileAccess.READ)
	if file:
		var text: String = file.get_as_text()
		if text and text.length() > 0:
			_scores_history = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		save_score()
	_scores_history.sort_custom(compare_scores)
	print(_scores_history)

func compare_scores(a, b) -> bool:
	return b.score < a.score

func get_score_history() -> Array[int]:
	var high_scores: Array[int] = []
	for score in _scores_history:
		high_scores.push_back(int(score.score))
	return high_scores
