extends Node

var thread = Thread.new()

var delta_conjunto = 0.0

var label_thread

func _ready():
	label_thread = get_node("LabelThread")
	
	thread.start(self, "_work", "hello")   # object, method name, userdata
	
	set_process(true)

func end_thread():
	delta_conjunto = 100

func _work(userdata):
	# runs on the other thread
	print(userdata)
	
	while ( delta_conjunto < 10):
		if int(delta_conjunto) % 2 == 0:
			label_thread.set_text(userdata)
	
	call_deferred("_on_done")              # hand the result back to the main thread

func _on_done():
	thread.wait_to_finish()

func _process(delta):
	delta_conjunto += delta
	
	if delta_conjunto >= 10:
		label_thread.set_text("MAIN FIM")
	elif int(delta_conjunto) % 2 == 1:
		label_thread.set_text("MAIN")
	