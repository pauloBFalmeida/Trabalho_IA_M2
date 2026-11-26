extends Spatial

export(NodePath) var personagem_path

func get_personagem():
	return get_node(personagem_path)
