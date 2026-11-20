# Input Movimento
# Controlador do Input de Movimento do Personagem
#
extends Node

export(NodePath) var personagem_path

export(float) var velocidade = 100.0

const MAX_INPUT_VALUE = 128
const DEADZONE = 0.2

const DEADZONE_SQUARED = 30

var personagem
var label
var label2

func _ready():
	personagem = get_node(personagem_path)
	label = personagem.get_node("Label")
	label2 = personagem.get_node("Label1")
	
	set_process(true)

func _process(delta):
	# movimento
	var direcao = Vector2(0, 0)
	
	# input D pad
	if Input.is_action_pressed("move_left"):
		direcao.x -= MAX_INPUT_VALUE
	if Input.is_action_pressed("move_right"):
		direcao.x += MAX_INPUT_VALUE
	if Input.is_action_pressed("move_up"):
		direcao.y -= MAX_INPUT_VALUE
	if Input.is_action_pressed("move_down"):
		direcao.y += MAX_INPUT_VALUE
	
	# input Analogico
	var analog = Vector2(
		Input.get_joy_axis(0, JOY_ANALOG_0_X),
		Input.get_joy_axis(0, JOY_ANALOG_0_Y)
	)
	# desconsidera drift e noise
	if abs(analog.x) > DEADZONE_SQUARED:
		direcao.x += analog.x
	if abs(analog.y) > DEADZONE_SQUARED:
		direcao.y += analog.y
	
	# var length = analog.length()
	# if length > DEADZONE:
	# 	# rescale so movement starts from 0 right after the deadzone
	# 	var strength = (length - DEADZONE) / (1.0 - DEADZONE)
	# 	if strength > 1:
	# 		strength = 1
	# 	direcao += analog * strength
	# 	label.set_text(str(direcao.x) + " : " + str(direcao.y))
	
	
	direcao = direcao.clamped(MAX_INPUT_VALUE) / MAX_INPUT_VALUE
	label.set_text(" : %.2f : %.2f" % [direcao.x, direcao.y])
	
	var length = direcao.length()
	# rescale so movement starts from 0 right after the deadzone
	var strength = length / 1.0
	if strength > 1:
		strength = 1
	direcao = direcao * strength

	var n_direcao = direcao.normalized()
	label2.set_text("n: %.2f : %.2f" % [n_direcao.x, n_direcao.y])
	
	var motion = personagem.move(direcao * velocidade * delta)
	


	## se tiver movimento, movimenta
	# if direcao.length_squared() > 1:
	# 	# direcao = direcao.normalized()
	# 	direcao = direcao / MAX_INPUT_VALUE
	# 	label.set_text(str(direcao.x) + " : " + str(direcao.y))
	# 	var n_direcao = direcao.normalized()
	# 	label2.set_text("n: %.2f : %.2f" % [n_direcao.x, n_direcao.y])
		
	# 	var motion = personagem.move(direcao * velocidade * delta)