# Input Movimento
# Controlador do Input de Movimento do Personagem
#
extends Node

export(NodePath) var personagem_path

export(float) var velocidade = 1.0

const MAX_INPUT_VALUE = 128
const DEADZONE = 30

var personagem

func _ready():
	personagem = get_node(personagem_path)
	
	set_fixed_process(true)

func _fixed_process(delta):
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
	
	
	# TODO: REMOVE
	print("REMOVER ISSO DO INPUT MOVIMENTO")
	if Input.is_action_pressed("ui_left"):
		direcao.x -= MAX_INPUT_VALUE
	if Input.is_action_pressed("ui_right"):
		direcao.x += MAX_INPUT_VALUE
	if Input.is_action_pressed("ui_up"):
		direcao.y -= MAX_INPUT_VALUE
	if Input.is_action_pressed("ui_down"):
		direcao.y += MAX_INPUT_VALUE
	
	# input Analogico
	var analog = Vector2(
		Input.get_joy_axis(0, JOY_ANALOG_0_X),
		Input.get_joy_axis(0, JOY_ANALOG_0_Y)
	)
	# desconsidera drift e noise
	if abs(analog.x) > DEADZONE:
		direcao.x += analog.x
	if abs(analog.y) > DEADZONE:
		direcao.y += analog.y
	
	# normaliza mantendo o range do analogico
	direcao = direcao.clamped(MAX_INPUT_VALUE) / MAX_INPUT_VALUE

	# movimento 2D (x, y) -> 3D (x, 0, z)
	var movimento = Vector3(direcao.x, 0, direcao.y) * velocidade * delta
	var motion = personagem.move(movimento)
