extends Node

onready var background = get_node("Sprite")
onready var tween = get_node("Tween")

onready var tela = get_node("Tela")
onready var btn_menu = get_node("Tela/ButtonMenu")

func _ready():
	tween.connect("tween_complete", self, "_on_tween_complete")
	
	background.hide()
	tela.hide()

func exibir():
	var cor_start = background.get_modulate()
	cor_start.a = 0.0
	var cor_end = background.get_modulate()

	tween.interpolate_property(
		background, 
		"modulate", 
		cor_start, 
		cor_end, 
		0.8,
		Tween.TRANS_QUAD, 
		Tween.EASE_OUT
	)
	tween.start()
	background.show()

func _on_tween_complete(objeto, chave):
	tela.show()
	btn_menu.grab_focus()

func _on_ButtonMenu_pressed():
	get_tree().change_scene("res://cenas/menu/MainMenu.tscn")
