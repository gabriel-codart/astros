extends CharacterBody2D

@export var speed: float = 100.0
@onready var marker: Marker2D = $Marker2D
@onready var attack_area: Area2D = $AttackArea
@onready var blast_scene: PackedScene = preload("res://Explosions and Particles/blast.tscn")
@onready var shoot_cooldown: Timer = $ShootCooldown

var player_in_range: bool = false

func _ready() -> void:
	# Conectar sinais da área
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)

func _physics_process(_delta: float) -> void:
	# Movimento para baixo
	move()
	# Se sair da tela, destruir
	verify_viewport()
	# Se o player estiver na área, atira
	shoot()

func move() -> void:
	velocity.y = speed
	move_and_slide()

func verify_viewport() -> void:
	var screen_size = get_viewport_rect().size
	# margem de tolerância (pra garantir que entrou e saiu totalmente da tela)
	var margin = 200

	if global_position.y > screen_size.y + margin:
		queue_free()

func shoot() -> void:
	if player_in_range and shoot_cooldown.is_stopped():
		var blast = blast_scene.instantiate()
		blast.is_protagonist = false
		blast.position = marker.global_position
		get_parent().add_child(blast)
		# Inicia o Cooldown
		shoot_cooldown.start()

func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("Prota"):
		print('entrou')
		player_in_range = true

func _on_attack_area_body_exited(body: Node) -> void:
	if body.is_in_group("Prota"):
		player_in_range = false
