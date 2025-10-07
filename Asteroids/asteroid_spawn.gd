extends Node2D

@export var asteroid_scene: PackedScene = preload("res://Asteroids/asteroid.tscn")
@export var spawn_interval: float = 3.0   # tempo entre spawns
@export var multiplicator: float = 1.0   # multiplicador
@export var min_speed: float = 80.0
@export var max_speed: float = 200.0
@export var spawn_range_x: Vector2 = Vector2(0, 720)  # limites horizontais do spawn
@export var rotation_speed_range: Vector2 = Vector2(-90, 90) # graus por segundo

var spawn_timer: Timer

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	spawn_asteroid()

func spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate()
	# Posição inicial aleatória no topo da tela
	asteroid.position = Vector2(
		randf_range(spawn_range_x.x, spawn_range_x.y),
		-200
	)
	# Velocidade e rotação
	var speed = randf_range(min_speed, max_speed) * multiplicator
	var rot_speed = randf_range(rotation_speed_range.x, rotation_speed_range.y)
	asteroid.set_meta("speed", speed)
	asteroid.set_meta("rot_speed", rot_speed)
	add_child(asteroid)

func _process(delta: float) -> void:
	for asteroid in get_children():
		if asteroid is CharacterBody2D or asteroid is Node2D:
			# Movimento para baixo
			var speed = asteroid.get_meta("speed", 0)
			asteroid.position.y += speed * delta
			# Rotação (em graus)
			var rot_speed = asteroid.get_meta("rot_speed", 0)
			asteroid.rotation_degrees += rot_speed * delta
			# Remover se sair da tela
			if asteroid.position.y > 1280 + 200:
				asteroid.queue_free()
