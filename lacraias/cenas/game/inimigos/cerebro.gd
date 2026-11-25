extends Node

const IDLE = 0
const PERSEGUE = 1
const ATACA = 2

const PERSEGUE_RANGE = 0.5
const ATACA_RANGE = 0.1

var jogador
var corpo
var estado_atual = IDLE


var label_estado

func set_jogador(_jogador):
	jogador = _jogador

func _ready():
	corpo = get_parent()
	label_estado = get_node("../Label")

func _fixed_process(delta):
	var prox_estado = _verifica_prox_estado()
	if prox_estado != estado_atual:
		_change_state(prox_estado)

func _verifica_prox_estado():
	var corpo_pos = corpo.get_translation()
	var jog_pos = jogador.get_translation()
	var dist = corpo_pos.distance_to(jog_pos)
	print(dist)
	if dist <= ATACA_RANGE:
		return ATACA
	if dist <= PERSEGUE_RANGE:
		return PERSEGUE
	return IDLE

func _change_state(prox_estado):
	estado_atual = prox_estado
	if estado_atual == IDLE:
		label_estado.set_text("Estado: IDLE")
	elif estado_atual == PERSEGUE:
		label_estado.set_text("Estado: PERSEGUE")
	elif estado_atual == ATACA:
		label_estado.set_text("Estado: ATACA")

func esta_perseguindo():
	return estado_atual == PERSEGUE

func esta_atacando():
	return estado_atual == ATACA
