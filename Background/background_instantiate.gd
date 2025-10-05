extends Node

var background_scene: PackedScene = preload("res://Background/background.tscn")
var current_bg: Node = null

func _ready():
	spawn_background()

func spawn_background():
	if current_bg:
		current_bg.queue_free()  # remove se já existir
	current_bg = background_scene.instantiate()
	get_tree().root.add_child.call_deferred(current_bg)
	current_bg.z_index = -100

func reset_background():
	spawn_background()
