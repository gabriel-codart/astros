extends Node

var background_scene := preload("res://Background/background.tscn")

func _ready():
	var bg = background_scene.instantiate()
	get_tree().root.add_child.call_deferred(bg)
	bg.z_index = -100
