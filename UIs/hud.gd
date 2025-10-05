extends CanvasLayer

signal pause

@onready var life_label: Label = $Control/LifeContainer/LifeLabel
@onready var score_label: Label = $Control/ScoreContainer/ScoreLabel

@onready var btn_left = $Control/ButtonsContainer/HBoxContainer/MoveContainer/LeftButton
@onready var btn_right = $Control/ButtonsContainer/HBoxContainer/MoveContainer/RightButton
@onready var btn_fire = $Control/ButtonsContainer/HBoxContainer/FireButton

var lives: int = 3
var score: int = 0

func _ready() -> void:
	# Sinais Botão Left
	btn_left.button_down.connect(_on_left_pressed)
	btn_left.button_up.connect(_on_left_released)
	# Sinais Botão Right
	btn_right.button_down.connect(_on_right_pressed)
	btn_right.button_up.connect(_on_right_released)
	# Sinais Botão Fire
	btn_fire.button_down.connect(_on_fire_pressed)
	btn_fire.button_up.connect(_on_fire_released)

func update_lives(value: int) -> void:
	lives = max(value, 0)
	life_label.text = "❤".repeat(lives)

func add_score(points: int) -> void:
	score += points
	score_label.text = str(score).pad_zeros(4)

func _on_pause_button_pressed():
	emit_signal("pause")

# Botão Left
func _on_left_pressed():
	Input.action_press("left")
func _on_left_released():
	Input.action_release("left")
# Botão Right
func _on_right_pressed():
	Input.action_press("right")
func _on_right_released():
	Input.action_release("right")
# Botão Fire
func _on_fire_pressed():
	Input.action_press("fire")
func _on_fire_released():
	Input.action_release("fire")
