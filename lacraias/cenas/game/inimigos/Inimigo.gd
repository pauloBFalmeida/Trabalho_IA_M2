extends KinematicBody

export(NodePath) var jogador_path
export(NodePath) var mesh_imagem_path
export(NodePath) var cerebro_path

export(float) var velocidade = 0.2
export(int) var dano_ataque = 15

var jogador
var cerebro

var mesh_imagem
var ultimo_angulo = 0.0

var tween
var sprite_ataque
var timer_ataque

var esta_cooldown_ataque = false

# Ready
# ---------------------------------------------------------

func _ready():
	jogador = get_node(jogador_path)
	mesh_imagem = get_node(mesh_imagem_path)
	
	cerebro = get_node(cerebro_path)
	cerebro.set_fixed_process(true)
	
	tween = get_node("Tween")
	tween.connect("tween_complete", self, "_on_tween_complete")
	sprite_ataque = get_node("Sprite3DAtaque")
	sprite_ataque.hide()
	timer_ataque = get_node("TimerAtaque")


# ---------------------------------------------------------
# Movimento
# ---------------------------------------------------------

# Acoes de Movimento
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


# ---------------------------------------------------------
# Ataque
# ---------------------------------------------------------

func atacar_jogador():
	if esta_cooldown_ataque:
		return
	
	esta_cooldown_ataque = true
	timer_ataque.start()
	
	cerebro.set_imovel(true)
	
	_anim_ataque()
	jogador.receber_dano(dano_ataque)


func _on_TimerAtaque_timeout():
	esta_cooldown_ataque = false
	cerebro.set_imovel(false)

# Tween
# ---------------------------------------------------------

func _anim_ataque():
	tween.interpolate_property(
		sprite_ataque, 
		"transform/scale", 
		Vector3(1, 1, 1), 
		Vector3(0.2, 0.2, 0.2), 
		timer_ataque.get_wait_time(), 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_IN
	)
	tween.start()
	sprite_ataque.show()

func _on_tween_complete(objeto, chave):
	sprite_ataque.hide()

