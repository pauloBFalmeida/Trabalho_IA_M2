extends KinematicBody

export(NodePath) var jogador_path
export(NodePath) var mesh_imagem_path
export(NodePath) var cerebro_path

export(float) var velocidade = 0.2

var jogador
var cerebro

var mesh_imagem
var ultimo_angulo = 0.0

# Ready
# ---------------------------------------------------------

func _ready():
	jogador = get_node(jogador_path)
	mesh_imagem = get_node(mesh_imagem_path)
	
	cerebro = get_node(cerebro_path)
	cerebro.set_fixed_process(true)
	
	_anim()

# Acoes do inimigo
# ---------------------------------------------------------

func jogador_dentro_range(alcance):
	var alcance_sqrd = alcance * alcance
	var distancia_sqrd = get_translation().distance_squared_to(jogador.get_translation())
	return distancia_sqrd <= alcance_sqrd

func andar_ate_jogador(delta):
	# move
	var direcao = _direcao_do_player()
	var mover = direcao * velocidade * delta
	move(mover)
	# olha
	_olhar(direcao)

# Helpers do movimento
# ---------------------------------------------------------

func _direcao_do_player():
	return (jogador.get_translation() - get_translation()).normalized()

## Vira para a direcao
func _olhar(direcao):
	if abs(direcao.x) + abs(direcao.z) > 0.01:
		ultimo_angulo = atan2(direcao.x, direcao.z)
	mesh_imagem.set_rotation(Vector3(0, 0, ultimo_angulo))

# Tween
# ---------------------------------------------------------

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
