extends Node

var label_fps
var label_p_fps
var thread_test

func _ready():
	set_process(true)
	set_fixed_process(true)
	label_fps = get_node("LabelFPS")
	label_p_fps = get_node("LabelPFPS")
	thread_test = get_node("ThreadTest")

func _process(delta):
	label_fps.set_text("FPS: %.1f" % (1 / delta))
	
	if Input.is_action_pressed("btn_select"):
		thread_test.end_thread()
		call_deferred("_voltar_menu")

func _fixed_process(delta):
	label_p_fps.set_text("P FPS: %.1f" % (1 / delta))

func _voltar_menu():
	get_tree().change_scene("res://cenas/menu/MainMenu.tscn")
