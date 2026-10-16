extends Node

var label_fps
var label_p_fps

func _ready():
	set_process(true)
	set_fixed_process(true)
	label_fps = get_node("LabelFPS")
	label_p_fps = get_node("LabelPFPS")

func _process(delta):
	label_fps.set_text("FPS: %.1f" % (1 / delta))
	
	if Input.is_action_pressed("start_action"):
		get_tree().change_scene("res://cenas/menu/MainMenu.tscn")

func _fixed_process(delta):
	label_p_fps.set_text("P FPS: %.1f" % (1 / delta))
