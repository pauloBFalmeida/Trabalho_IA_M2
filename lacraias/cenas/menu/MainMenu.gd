extends Control

var label_debug

func _ready():
	var btn_jogar = get_node("ButtonJogar")
	label_debug = get_node("LabelDebug")
	btn_jogar.grab_focus()

func _on_ButtonSair_pressed():
	get_tree().quit()

func _on_ButtonJogar_pressed():
	get_tree().change_scene("res://cenas/game/Game.tscn")
