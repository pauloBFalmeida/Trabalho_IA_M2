extends KinematicBody

const SPEED = 0.20

var jogador
var cerebro

var mesh_imagem
var ultimo_angulo = 0.0

export(NodePath) var jogador_path

export(NodePath) var mesh_imagem_path

func _ready():
	jogador = get_node(jogador_path)
	mesh_imagem = get_node(mesh_imagem_path)
	
	cerebro = get_node("Cerebro")
	cerebro.set_jogador(jogador)
	
	cerebro.set_fixed_process(true)
	set_fixed_process(true)
	
	_anim()

func _fixed_process(delta):
	if cerebro.esta_perseguindo():
		var direcao = _direcao_do_player()
		var mover = direcao * SPEED * delta
		move(mover)
		_olhar(direcao)
	elif cerebro.esta_atacando():
		print("Ataque")


func _direcao_do_player():
	return (jogador.get_translation() - get_translation()).normalized()

func _olhar(direcao):
	if abs(direcao.x) + abs(direcao.z) > 0.01:
		ultimo_angulo = atan2(direcao.x, direcao.z)
	mesh_imagem.set_rotation(Vector3(0, 0, ultimo_angulo))

func _anim():
	var tween = get_node("Tween")
	tween.interpolate_property(
		self, 
		"transform/translation", 
		Vector3(0, 0, 0), 
		Vector3(0.15, 0, 0.15), 
		1, 
		Tween.TRANS_QUART, 
		Tween.EASE_IN_OUT
	)
	tween.start()
