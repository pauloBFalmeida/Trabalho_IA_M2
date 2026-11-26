extends KinematicBody

export(NodePath) var jogador_path
export(NodePath) var mesh_imagem_path
export(NodePath) var cerebro_path
export(NodePath) var sprite_visao_path

export(float) var velocidade = 0.2
export(int) var dano_ataque = 15

export(int) var vida_max = 50

export(float) var forca_empurrao = 0.30

export(float) var angulo_visao = 80.0
var cos_meio_sqrd

var jogador
var cerebro

var mesh_imagem
var ultimo_angulo = 0.0

var sprite_visao

var tween
var sprite_notify
var timer_ataque
var mesh_notify_exclama
var mesh_notify_interrog

onready var tween_empurrao = get_node("TweenEmpurrao")

var esta_cooldown_ataque = false

var vida

# Ready
# ---------------------------------------------------------

func _ready():
	add_to_group("inimigos")
	add_user_signal("matado")
	
	jogador = get_node(jogador_path)
	mesh_imagem = get_node(mesh_imagem_path)
	sprite_visao = get_node(sprite_visao_path)
	
	cerebro = get_node(cerebro_path)
	cerebro.set_fixed_process(true)
	
	tween = get_node("Tween")
	tween.connect("tween_complete", self, "_on_tween_complete")
	sprite_notify = get_node("Sprite3DNotify")
	mesh_notify_exclama = get_node("Sprite3DNotify/PlaneExclama")
	mesh_notify_interrog = get_node("Sprite3DNotify/PlaneInterrog")
	sprite_notify.hide()
	timer_ataque = get_node("TimerAtaque")

	var c = cos(deg2rad(angulo_visao * 0.5))
	cos_meio_sqrd = c * c
	
	vida = vida_max


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

func jogador_no_cone_visao(alcance):
	var alcance_sqrd = alcance * alcance

	var direcao = jogador.get_translation() - get_translation()
	direcao.y = 0
	var dist_sqrd = direcao.length_squared()

	if dist_sqrd > alcance_sqrd or dist_sqrd < 0.0001:
		return false

	var frente = Vector3(sin(ultimo_angulo), 0, cos(ultimo_angulo))
	var dot = frente.dot(direcao)
	if dot <= 0:
		return false                  # behind the enemy

	# dot / dist >= cos(half angle), squared so there is no sqrt
	return dot * dot >= cos_meio_sqrd * dist_sqrd

# Helpers do movimento
# ---------------------------------------------------------

func _direcao_do_player():
	return (jogador.get_translation() - get_translation()).normalized()

## Vira para a direcao
func _olhar(direcao):
	if abs(direcao.x) + abs(direcao.z) > 0.01:
		ultimo_angulo = atan2(direcao.x, direcao.z)
	mesh_imagem.set_rotation(Vector3(0, 0, ultimo_angulo))
	
	if sprite_visao:
		sprite_visao.set_rotation(Vector3(0, ultimo_angulo, 0))


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
	mesh_notify_interrog.hide()
	mesh_notify_exclama.show()
	_tween_anim()

func _anim_atencao():
	mesh_notify_exclama.hide()
	mesh_notify_interrog.show()
	_tween_anim()

func _tween_anim():
	tween.interpolate_property(
		sprite_notify, 
		"transform/scale", 
		Vector3(1, 1, 1), 
		Vector3(0.2, 0.2, 0.2), 
		timer_ataque.get_wait_time(), 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_IN
	)
	tween.start()
	sprite_notify.show()

func _on_tween_complete(objeto, chave):
	sprite_notify.hide()

# ---------------------------------------------------------
# Vida
# ---------------------------------------------------------

func receber_dano(dano):
	vida -= dano
	
	if vida <= 0:
		_matar()
		return
	
	_anim_atencao()
	_empurrao()
	

func receber_cura(cura):
	vida = min(vida + cura, vida_max)

func _matar():
	emit_signal("matado")
	
	mesh_imagem.hide()
	cerebro.queue_free()
	sprite_notify.queue_free()
	sprite_visao.queue_free()
	
	# espera 2 seg
	for i in range(60):
		yield(get_tree(), "fixed_frame")
	
	queue_free()

# ---------------------------------------------------------
# Vida
# ---------------------------------------------------------

func _empurrao():
	var direcao = _direcao_do_player()
	direcao = direcao * -1
	direcao = direcao * forca_empurrao
	
	tween_empurrao.interpolate_property(
		self, 
		"transform/translation", 
		get_translation(),
		get_translation() + direcao, 
		0.2, 
		Tween.TRANS_EXPO, 
		Tween.EASE_OUT
	)
	tween_empurrao.start()
