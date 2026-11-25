extends Node

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("btn_select"):
		call_deferred("_voltar_menu")

func _voltar_menu():
	get_tree().change_scene("res://cenas/menu/MainMenu.tscn")
