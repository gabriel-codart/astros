extends CharacterBody2D

@export var speed: float = 300.0
@onready var blast_scene: PackedScene = preload("res://Explosions and Particles/blast.tscn")

@onready var marker_left: Marker2D = $MarkerLeft
@onready var marker_right: Marker2D = $MarkerRight
@onready var shoot_cooldown: Timer = $ShootCooldown

func _physics_process(_delta: float) -> void:
	# Movimento
	move()
	# Disparo
	shoot()

func move() -> void:
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func shoot() -> void:
	if Input.is_action_just_pressed("fire") and shoot_cooldown.is_stopped():
		# Criar projétil da esquerda
		var blast_left = blast_scene.instantiate()
		blast_left.is_protagonist = true
		blast_left.position = marker_left.global_position
		get_parent().add_child(blast_left)
		# Criar projétil da direita
		var blast_right = blast_scene.instantiate()
		blast_right.is_protagonist = true
		blast_right.position = marker_right.global_position
		get_parent().add_child(blast_right)
		# Inicia o Cooldown
		shoot_cooldown.start()
