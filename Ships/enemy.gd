extends CharacterBody2D

@export var speed: float = 100.0
@export var health: int = 1

@onready var marker: Marker2D = $Marker2D
@onready var attack_area: Area2D = $AttackArea
@onready var blast_scene: PackedScene = preload("res://Explosions and Particles/blast.tscn")
@onready var shot_scene: PackedScene = preload("res://Explosions and Particles/shot.tscn")
@onready var explosion_scene: PackedScene = preload("res://Explosions and Particles/explosion.tscn")
@onready var shoot_cooldown: Timer = $ShootCooldown
@onready var anim: AnimationPlayer = $AnimationPlayer

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
		get_parent().add_child.call_deferred(blast)
		spawn_shot_fire(marker.global_position)
		# Inicia o Cooldown
		shoot_cooldown.start()

func spawn_shot_fire(marker_position: Vector2) -> void:
	var shot_fire = shot_scene.instantiate()
	shot_fire.is_prota = false
	shot_fire.position = marker_position
	get_parent().add_child.call_deferred(shot_fire)

func spawn_explosion() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	get_parent().add_child.call_deferred(explosion)

func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("Prota"):
		player_in_range = true

func _on_attack_area_body_exited(body: Node) -> void:
	if body.is_in_group("Prota"):
		player_in_range = false

# ==============================
# VIDA / DANO / MORTE
# ==============================

func take_damage(amount: int) -> void:
	if health <= 0:
		return
	health -= amount
	
	if health > 0:
		anim.play("hurt")
	else:
		die()

func die() -> void:
	spawn_explosion()
	queue_free()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	take_damage(1)
