extends KinematicBody2D

const SPEED = 40.0

var jogador
var cerebro

export(NodePath) var jogador_path

func _ready():
	jogador = get_node(jogador_path)
	cerebro = get_node("Cerebro")
	cerebro.set_jogador(jogador)
	
	cerebro.set_process(true)
	set_fixed_process(true)

func _fixed_process(delta):
	if cerebro.esta_perseguindo():
		var mover = _direcao_do_player() * SPEED * delta
		mover = move(mover)
	elif cerebro.esta_atacando():
		print("Ataque")


func _direcao_do_player():
	return (jogador.get_global_pos() - get_global_pos()).normalized()
