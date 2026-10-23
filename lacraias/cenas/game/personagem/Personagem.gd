# Personagem
#
#

extends KinematicBody2D

const SPEED = 100.0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# movimento
	var dir = Vector2(0, 0)
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	# se tiver movimento, movimenta
	if dir.length() > 0:
		dir = dir.normalized()
		var motion = move(dir * SPEED * delta)