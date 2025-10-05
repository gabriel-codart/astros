extends CharacterBody2D

signal died

@export var speed: float = 300.0
@export var health: int = 1

@onready var blast_scene: PackedScene = preload("res://Explosions and Particles/blast.tscn")
@onready var shot_scene: PackedScene = preload("res://Explosions and Particles/shot.tscn")
@onready var explosion_scene: PackedScene = preload("res://Explosions and Particles/explosion.tscn")
@onready var marker_left: Marker2D = $MarkerLeft
@onready var marker_right: Marker2D = $MarkerRight
@onready var shoot_cooldown: Timer = $ShootCooldown
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	initiate_score()
	update_health_ui()

func _physics_process(_delta: float) -> void:
	# Movimento
	move()
	# Loop Horizontal
	horizontal_loop()
	# Disparo
	shoot()

func move() -> void:
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func horizontal_loop() -> void:
	var screen_width = get_viewport_rect().size.x
	if position.x < -30:
		position.x = screen_width + 30
	elif position.x > screen_width + 30:
		position.x = -30

func shoot() -> void:
	if Input.is_action_just_pressed("fire") and shoot_cooldown.is_stopped():
		# Criar projétil da esquerda
		var blast_left = blast_scene.instantiate()
		blast_left.is_protagonist = true
		blast_left.position = marker_left.global_position
		get_parent().add_child.call_deferred(blast_left)
		spawn_shot_fire(marker_left.global_position)
		# Criar projétil da direita
		var blast_right = blast_scene.instantiate()
		blast_right.is_protagonist = true
		blast_right.position = marker_right.global_position
		get_parent().add_child.call_deferred(blast_right)
		spawn_shot_fire(marker_right.global_position)
		# Inicia o Cooldown
		shoot_cooldown.start()

func spawn_shot_fire(marker_position: Vector2) -> void:
	var shot_fire = shot_scene.instantiate()
	shot_fire.is_prota = true
	shot_fire.position = marker_position
	get_parent().add_child.call_deferred(shot_fire)

func spawn_explosion() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	get_parent().add_child.call_deferred(explosion)

# ==============================
# VIDA / DANO / MORTE
# ==============================

func take_damage(amount: int) -> void:
	print(health)
	if health <= 0:
		return
	health -= amount
	update_health_ui()
	
	if health > 0:
		anim.play("hurt")
	else:
		anim.play("dead")
		die()

func die() -> void:
	spawn_explosion()

func initiate_score() -> void:
	var hud = get_tree().get_root().get_node("Game/HUD")
	if hud and hud.has_method("add_score"):
		hud.add_score(0)

func update_health_ui() -> void:
	var hud = get_tree().get_root().get_node("Game/HUD")
	if hud and hud.has_method("update_lives"):
		hud.update_lives(health)

func _on_area_2d_area_entered(area):
	if area.is_in_group("Blast") or area.is_in_group("Asteroid") or area.is_in_group("Enemy"):
		take_damage(1)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dead":
		emit_signal("died")
		queue_free()
