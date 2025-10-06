extends Node

const MAX_PLAYERS := 10  # limite de sons simultâneos (pode ajustar)
var players: Array[AudioStreamPlayer] = []

# --- Sons pré-carregados ---
@onready var sfx_click = preload("res://Assets/SFX/click.wav")
@onready var sfx_explosion_big = preload("res://Assets/SFX/explosion big.wav")
@onready var sfx_explosion_small = preload("res://Assets/SFX/explosion small.wav")
@onready var sfx_laser = preload("res://Assets/SFX/laserShoot.wav")

func _ready() -> void:
	# Cria um pool de players
	for i in range(MAX_PLAYERS):
		var player := AudioStreamPlayer.new()
		player.bus = "SFX" # use um Audio Bus dedicado se quiser mixar depois
		add_child(player)
		players.append(player)

# --- Função principal de tocar som ---
func play(stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	# Encontra um player livre
	for p in players:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.pitch_scale = pitch_scale
			p.play()
			return
	# Se todos estiverem ocupados, sobrescreve o primeiro
	var fallback = players[0]
	fallback.stream = stream
	fallback.volume_db = volume_db
	fallback.pitch_scale = pitch_scale
	fallback.play()

# --- Funções auxiliares ---
func click():
	play(sfx_click)

func explosion_big():
	play(sfx_explosion_big)

func explosion_small():
	play(sfx_explosion_small)

func laser():
	play(sfx_laser, -2.0)
