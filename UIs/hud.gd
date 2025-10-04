extends Control

@onready var life_label: Label = $LifeContainer/LifeLabel
@onready var score_label: Label = $ScoreContainer/ScoreLabel

var lives: int = 3
var score: int = 0

func update_lives(value: int) -> void:
	lives = max(value, 0)
	life_label.text = "❤".repeat(lives)

func add_score(points: int) -> void:
	score += points
	score_label.text = str(score).pad_zeros(4)
