extends Node

export(float) var PERSEGUIR_RANGE = 0.5
export(float) var ATACAR_RANGE = 0.12
export(float) var MUITO_PROXIMO_RANGE = 0.2

const IDLE = 0
const PERSEGUIR = 1
const ATACAR = 2

var estado_atual = IDLE

var inimigo

var esta_imovel = false

# Ready e Process
# ---------------------------------------------------------

func _ready():
	inimigo = get_parent()

func _fixed_process(delta):
	# acoes do estado atual
	_acao_estado(delta)

	# verifica proximo estado
	var prox_estado = _verifica_prox_estado()
	if prox_estado != estado_atual:
		_troca_estado(prox_estado)

# Troca de Estados
# ---------------------------------------------------------

func _verifica_prox_estado():
	if esta_imovel:
		return IDLE
	
	if inimigo.jogador_dentro_range(ATACAR_RANGE):
		return ATACAR
	if inimigo.jogador_no_cone_visao(PERSEGUIR_RANGE) or inimigo.jogador_dentro_range(MUITO_PROXIMO_RANGE):
		return PERSEGUIR
	return IDLE

func _troca_estado(prox_estado):
	estado_atual = prox_estado
	# if estado_atual == IDLE:
	# 	print("Estado: IDLE")
	# elif estado_atual == PERSEGUIR:
	# 	print("Estado: PERSEGUIR")
	# elif estado_atual == ATACAR:
	# 	print("Estado: ATACAR")

# Acao de cada Estado
# ---------------------------------------------------------

func _acao_estado(delta):
	if estado_atual == IDLE:
		pass
	elif estado_atual == PERSEGUIR:
		inimigo.andar_ate_jogador(delta)
	elif estado_atual == ATACAR:
		inimigo.atacar_jogador()

# Externo
# ---------------------------------------------------------

func set_imovel(_imovel):
	esta_imovel = _imovel