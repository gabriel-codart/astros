extends Node

@onready var main_theme = preload("res://Assets/Songs/Dark Cinematic Space Pads Loop - Music by ido berg from Pixabay.mp3")
@onready var gameplay_theme = preload("res://Assets/Songs/Workout Cyberpunk Music - Music by Tunetank from Pixabay.mp3")
@onready var game_over_theme = preload("res://Assets/Songs/Creepy Space - Music by Roland Horvers from Pixabay.mp3")

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var current_song: AudioStream = null

func _ready() -> void:
	audio_player.autoplay = false
	audio_player.stream_paused = false
	audio_player.volume_db = -4
	play(main_theme)

func play(song: AudioStream) -> void:
	# Se a música for a mesma, não faz nada
	if current_song == song:
		return
	current_song = song
	audio_player.stream = song
	audio_player.play()

func stop() -> void:
	audio_player.stop()
	current_song = null

func fade_volume(target_db: float, duration: float = 0.5) -> void:
	# Cria um tween para suavizar o volume
	var tween = create_tween()
	tween.tween_property(audio_player, "volume_db", target_db, duration)

func lower_volume() -> void:
	fade_volume(-12.0, 0.5) # abaixa suavemente (ajuste o valor conforme desejar)

func restore_volume() -> void:
	fade_volume(-4.0, 0.5) # volta ao volume padrão
