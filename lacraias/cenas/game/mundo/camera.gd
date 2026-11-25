extends Camera

export(NodePath) var personagem_path

export(int) var tolerancia = 50

const centro = Vector2(480, 272) / 2

var personagem
var tolerancia_sqrd
var cam = self

func _ready():
	personagem = get_node(personagem_path)
	tolerancia_sqrd = tolerancia * tolerancia
	
	set_fixed_process(true)

func _fixed_process(delta):
	seguir_personagem()

func seguir_personagem():
	var pos_personagem = personagem.get_global_transform().origin

	# atras da camera, ignore
	if cam.is_position_behind(pos_personagem):
		return Vector3(0, 0, 0)
	
	var pos_tela = cam.unproject_position(pos_personagem)
	var offset = pos_tela - centro
	# dentro do centro, ignore
	if offset.length_squared() < tolerancia_sqrd:
		return Vector3(0, 0, 0)

	# ponto na borda do circulo de tolerancia, na direcao do personagem
	var borda = centro + offset.normalized() * tolerancia

	# onde esse ponto da tela cai no plano do chao do personagem
	var origem = cam.project_ray_origin(borda)
	var normal = cam.project_ray_normal(borda)
	if abs(normal.y) < 0.001:
		return                      # camera horizontal, sem plano de chao
	var t = (pos_personagem.y - origem.y) / normal.y
	var ponto = origem + normal * t

	# move a camera ate o personagem ficar exatamente na borda
	cam.global_translate(pos_personagem - ponto)