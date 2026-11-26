extends Spatial

export(NodePath) var cerebro_path

onready var mesh_plane = get_node("Plane")

var cerebro

var alcance
var mostrar = false


func _ready():
	cerebro = get_node(cerebro_path)
	alcance = cerebro.PERSEGUIR_RANGE
	
	ajustar_tamanho(alcance)
	
	set_fixed_process(true)


func _fixed_process(delta):
	mostrar = (
		cerebro.estado_atual == cerebro.IDLE
		and
		not cerebro.esta_imovel
	)
	
	if not mostrar:
		hide()
		return
	
	show()

func ajustar_tamanho(tamanho):
	set_scale(Vector3(tamanho, tamanho, tamanho))
	# distancia do centro
	var trans = mesh_plane.get_translation()
	trans.z = trans.z - (trans.z * tamanho / 4)
	mesh_plane.set_translation(trans)
