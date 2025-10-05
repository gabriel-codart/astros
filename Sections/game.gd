extends Control

@onready var game_over_scene: PackedScene = preload("res://UIs/game_over.tscn")
@onready var pause_scene: PackedScene = preload("res://UIs/pause_menu.tscn")

@onready var prota: CharacterBody2D = $Prota
@onready var HUD: CanvasLayer = $HUD
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	prota.died.connect(_on_prota_died)
	HUD.pause.connect(_on_pause_pressed)

func _on_prota_died() -> void:
	# Instancia a tela Game Over
	var game_over_instance = game_over_scene.instantiate()
	# Conecta o sinal emitido pelo PauseMenu
	game_over_instance.fade_out.connect(_on_fade_out)
	# Adiciona o filho
	add_child.call_deferred(game_over_instance)

func _on_pause_pressed() -> void:
	# Pausa o jogo
	get_tree().paused = true
	# Instancia a tela de Pause
	var pause_instance = pause_scene.instantiate()
	# Conecta o sinal emitido pelo PauseMenu
	pause_instance.fade_out.connect(_on_fade_out)
	# Adiciona o filho
	add_child.call_deferred(pause_instance)

func _on_fade_out() -> void:
	anim.play("close")
