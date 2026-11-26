extends Node

var personagem

onready var mundo = get_node("Mundo")
onready var fim_jogo = get_node("FimJogo")

func _ready():
	personagem = mundo.get_personagem()
	personagem.connect("morreu", self, "_acabar_jogo")
	
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("btn_select"):
		call_deferred("_voltar_menu")

func _voltar_menu():
	get_tree().change_scene("res://cenas/menu/MainMenu.tscn")


func _acabar_jogo():
	yield(get_tree(), "fixed_frame")
	yield(get_tree(), "fixed_frame")
	fim_jogo.exibir()