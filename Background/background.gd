extends Node2D

# Lista de texturas que serão carregadas
var textures: Array[Texture2D] = []

# Tempo entre spawns
@export var spawn_interval: float = 12.0

# Velocidade mínima e máxima
@export var min_speed: float = 200.0
@export var max_speed: float = 250.0

# Timer para spawn
var spawn_timer: Timer

func _ready():
	# Carregar todas as imagens da pasta
	textures = [
		load("res://Assets/Background/Planet1.png"),
		load("res://Assets/Background/Planet2.png"),
	]

	# Criar o Timer via código
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)

	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func _on_spawn_timer_timeout():
	spawn_object()


func spawn_object():
	var sprite := Sprite2D.new()
	sprite.texture = textures.pick_random()

	# Posição inicial (Y=-200, X aleatório dentro da tela)
	var x_pos = randf_range(0, 720)
	sprite.position = Vector2(x_pos, -200)

	# Guardar velocidade como metadado
	var speed = randf_range(min_speed, max_speed)
	sprite.set_meta("speed", speed)

	add_child(sprite)


func _process(delta: float):
	for child in get_children():
		if child is Sprite2D:
			var speed = child.get_meta("speed")
			child.position.y += speed * delta

			# Se saiu da tela → liberar
			if child.position.y > 1280 + 200:
				child.queue_free()
