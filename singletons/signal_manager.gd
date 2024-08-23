extends Node

signal on_enemy_hit(points: int)
signal on_boss_killed(points: int)
signal on_create_bullet(
	pos: Vector2,
	dir: Vector2,
	life_span: float,
	speed: float,
	ob_type: Constants.ObjectType,
)

signal on_create_object(
	pos: Vector2,
	ob_type: Constants.ObjectType,
)

signal on_pickup_hit(points: int)
signal on_player_hit(lives: int)
signal on_score_updated(points: int)
signal on_level_started(lives: int)
signal on_level_completed
signal on_game_over
