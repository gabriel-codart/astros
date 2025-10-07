extends Node2D

@export var enemy_scene: PackedScene = preload("res://Ships/enemy.tscn")
@export var spawn_interval: float = 5.0   # tempo entre spawns
@export var multiplicator: float = 1.0   # multiplicador
@export var min_speed: float = 100.0
@export var max_speed: float = 200.0

var spawn_timer: Timer

func _ready() -> void:
	# Criar o Timer via código
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	# Posição inicial (fora da tela, Y=-200)
	enemy.position = Vector2(randf_range(0, 720), -200)
	# Guardar velocidade como metadado
	var speed = randf_range(min_speed, max_speed) * multiplicator
	enemy.set_meta("speed", speed)
	add_child.call_deferred(enemy)

func _process(delta: float) -> void:
	for enemy in get_children():
		if enemy is CharacterBody2D:
			var speed = enemy.get_meta("speed")
			enemy.position.y += speed * delta
			# Se saiu da tela → liberar
			if enemy.position.y > 1280 + 200:
				enemy.queue_free()
