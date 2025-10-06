extends Node2D

@export var speed_min: float = 80.0
@export var speed_max: float = 150.0
@onready var asteroid_small_scene: PackedScene = preload("res://Asteroids/asteroid.tscn") # usamos a mesma cena
@onready var explosion_scene: PackedScene = preload("res://Explosions and Particles/explosion.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D

var is_big: bool
var type_is_defined: bool = false
var velocity: Vector2
var rotation_speed: float

func _ready() -> void:
	# Collision Shape Único
	collision.shape = collision.shape.duplicate()
	# Define rotação e tipo
	rotation_speed = randf_range(-1.0, 1.0)
	if not type_is_defined:
		is_big = randf() < 0.4
	# Define sprite e colisão
	if is_big:
		sprite.texture = load("res://Assets/Asteroids/Asteroid Big.png")
		collision.shape.radius = 25
	else:
		var small_textures = [
			load("res://Assets/Asteroids/Asteroid Small 1.png"),
			load("res://Assets/Asteroids/Asteroid Small 2.png"),
		]
		sprite.texture = small_textures.pick_random()
		collision.shape.radius = 10
	# Movimento inicial
	velocity = Vector2(randf_range(-10, 10), randf_range(speed_min, speed_max))

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	position += velocity * delta
	# Se sair da tela → liberar
	if position.y > 1280 + 200:
		queue_free()

func spawn_small_asteroids() -> void:
	var num_smalls = randi_range(2, 3)
	for i in range(num_smalls):
		var small = asteroid_small_scene.instantiate()
		small.is_big = false
		small.type_is_defined = true
		small.position = position
		
		# movimento diagonal aleatório pra baixo
		var dir_x = randf_range(-100, 100)
		small.velocity = Vector2(dir_x, randf_range(speed_min, speed_max))
		
		get_parent().add_child.call_deferred(small)

func spawn_explosion(size: Vector2i) -> void:
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	explosion.scale = size
	get_parent().add_child.call_deferred(explosion)

func destroy() -> void:
	if is_big:
		SFXPlayer.explosion_big()
		spawn_small_asteroids()
		spawn_explosion(Vector2i(4.0, 4.0))
	else:
		SFXPlayer.explosion_small()
		spawn_explosion(Vector2i(2.0, 2.0))
	queue_free()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	destroy()

func _on_area_2d_body_entered(_body):
	destroy()
