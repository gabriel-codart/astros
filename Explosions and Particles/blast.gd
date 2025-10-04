extends Node2D

@export var speed: float = 500.0
var direction: Vector2
var is_protagonist: bool = true

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Configura sprite e direção conforme quem disparou
	if is_protagonist:
		sprite.texture = load("res://Assets/Explosions and Particles/Blast Prota.png")
		sprite.scale.y = 1
		direction = Vector2(0, -1) # pra cima
	else:
		sprite.texture = load("res://Assets/Explosions and Particles/Blast Enemy.png")
		sprite.scale.y = -1
		direction = Vector2(0, 1) # pra baixo


func _process(delta: float) -> void:
	# Move o projétil
	position += direction * speed * delta
	# Se sair da tela -> destruir
	if position.y < -100 or position.y > 1380:
		queue_free()

func _on_area_2d_body_entered(body):
	# Aqui futuramente vamos lidar com colisões (dano, explosão, etc.)
	queue_free()
