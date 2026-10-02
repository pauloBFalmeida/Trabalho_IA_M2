extends CharacterBody2D

@export var velocidade_movimento := 300.0


func _physics_process(_delta: float) -> void:
	# movimenta
	var direction := Input.get_vector(
		"esquerda", "direita",
		"cima", "baixo"
	)
	
	# se estiver se movendo
	if direction:
		velocity = direction * velocidade_movimento
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade_movimento)
		velocity.y = move_toward(velocity.y, 0, velocidade_movimento)

	move_and_slide()
