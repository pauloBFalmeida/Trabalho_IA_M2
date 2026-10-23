extends Node

var label_fps

func _ready():
	set_process(true)
	label_fps = get_node("LabelFPS")

func _process(delta):
	label_fps.set_text("FPS: %.1f" % (1 / delta))
	
	if Input.is_action_pressed("btn_select"):
		call_deferred("_voltar_menu")

func _voltar_menu():
	get_tree().change_scene("res://cenas/menu/MainMenu.tscn")
