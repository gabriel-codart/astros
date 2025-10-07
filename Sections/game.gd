extends Control

@onready var game_over_scene: PackedScene = preload("res://UIs/game_over.tscn")
@onready var pause_scene: PackedScene = preload("res://UIs/pause_menu.tscn")

@onready var prota: CharacterBody2D = $Prota
@onready var enemy_spawner: Node2D = $Enemies
@onready var asteroid_spawner: Node2D = $Asteroids
@onready var HUD: CanvasLayer = $HUD
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	SongPlayer.play(SongPlayer.gameplay_theme)
	prota.died.connect(_on_prota_died)
	HUD.increase_enemies.connect(_increase_enemies)
	HUD.increase_asteroids.connect(_increase_asteroids)
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

# Aumentando a Dificuldade

func _increase_enemies(spawn_interval: float, multiplicator: float) -> void:
	enemy_spawner.spawn_interval = spawn_interval
	enemy_spawner.multiplicator = multiplicator

func _increase_asteroids(spawn_interval: float, multiplicator: float) -> void:
	asteroid_spawner.spawn_interval = spawn_interval
	asteroid_spawner.multiplicator = multiplicator
