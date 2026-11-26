extends Node

export(NodePath) var plane_protag_frente_path
export(NodePath) var plane_protag_costas_path
export(NodePath) var plane_protag_soco_path

export(NodePath) var movimento_path

export(float) var alcance_soco = 0.35
export(int) var dano_soco = 30

var plane_protag_frente
var plane_protag_costas
var plane_protag_soco

var movimento

onready var timer_ataque = get_node("TimerAtaque")

var ataque_cooldown = false

func _ready():
	plane_protag_frente = get_node(plane_protag_frente_path)
	plane_protag_costas = get_node(plane_protag_costas_path)
	plane_protag_soco = get_node(plane_protag_soco_path)
	movimento = get_node(movimento_path)
	
	set_fixed_process(true)

func _fixed_process(delta):
	
	if Input.is_action_pressed("pad_cross") or Input.is_action_pressed("bump_R"):
		_atacar()


func _atacar():
	if ataque_cooldown:
		return
	
	ataque_cooldown = true
	timer_ataque.start()
	movimento.set_imovel(true)
	
	_mostrar_ataque()
	
	for inimigo in corpos_dentro:
		if inimigo.jogador_dentro_range(alcance_soco):
			inimigo.receber_dano(dano_soco)


func _on_TimerAtaque_timeout():
	ataque_cooldown = false
	movimento.set_imovel(false)
	_mostrar_idle()

func _mostrar_ataque():
	plane_protag_frente.hide()
	plane_protag_soco.show()

func _mostrar_idle():
	plane_protag_frente.show()
	plane_protag_soco.hide()



var corpos_dentro = []

func _on_Area_body_enter( body ):
	if body.is_in_group("inimigos"):
		corpos_dentro.append(body)

func _on_Area_body_exit( body ):
	if body.is_in_group("inimigos"):
		corpos_dentro.erase(body)
