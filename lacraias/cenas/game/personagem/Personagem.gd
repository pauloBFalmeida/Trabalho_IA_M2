## Personagem
##
##
extends KinematicBody

export(int) var max_vida = 100

onready var vida_ui = get_node("Vida")

var vida

func _ready():
	add_user_signal("morreu")
	
	vida = max_vida

func receber_dano(dano):
	# recebe o dano (min 0)
	vida = max(0, vida - dano)
	# update na ui
	vida_ui.set_vida(float(vida) / max_vida)
	
	# verifica se morreu
	if vida <= 0:
		_morrer()
		return


func _morrer():
	emit_signal("morreu")
	get_tree().set_pause(true)