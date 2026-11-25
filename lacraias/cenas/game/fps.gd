extends Label

func _ready():
	set_process(true)

func _process(delta):
	set_text("FPS: %.1f" % (1 / delta))