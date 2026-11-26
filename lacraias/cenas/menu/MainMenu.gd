extends Control


func _ready():
	get_tree().set_pause(false)
	
	var btn_jogar = get_node("ButtonJogar")
	btn_jogar.grab_focus()


func _on_ButtonSair_pressed():
	get_tree().quit()

func _on_ButtonJogar_pressed():
	get_tree().change_scene("res://cenas/game/Game.tscn")
