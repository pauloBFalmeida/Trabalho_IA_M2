extends Node2D

export(int) var x_vazio = 72
export(int) var x_cheio = 0

export(int) var w_vazio = 77
export(int) var w_cheio = 5

const rect_y = 0
const rect_h = 8

var sprite_bar 

func _ready():
	sprite_bar = get_node("SpriteBar")
	set_vida(1.0)

## Ajusta a vida para o valor passado na porcentagem entre [0.0, 1.0]
func set_vida(porcent):
	porcent = clamp(porcent, 0.0, 1.0)
	var _x = x_vazio + (x_cheio - x_vazio) * porcent
	var _w = (w_vazio - w_cheio) * porcent
	sprite_bar.set_region_rect(Rect2(_x, rect_y, _w, rect_h))
