extends Node

var threads = []
var mutex = Mutex.new()
var counter = 0
var finished = 0

var label_multi

func _ready():
	label_multi = get_node("LabelMulti")
	
#	for i in range(2):
#		var t = Thread.new()
#		t.start(self, "_work", i)
#		threads.append(t)
	

	var t = Thread.new()
	t.start(self, "_work", 0)
	threads.append(t)
	var t = Thread.new()
	t.start(self, "_work2", 1)
	threads.append(t)

func _work(id):
	for j in range(5):
	#	mutex.lock()
		counter += 1
	#	mutex.unlock()
	
	label_multi.set_text( label_multi.get_text() + "\n Thread %d done" % id)
	call_deferred("_on_finished")

func _work2(id):
	for j in range(5):
	#	mutex.lock()
		counter += 1
	#	mutex.unlock()
	
	label_multi.set_text( label_multi.get_text() + "\n Thread %d done" % id)
	call_deferred("_on_finished")

func _on_finished():
	finished += 1
	if finished == 5:
		for t in threads:
			t.wait_to_finish()
		label_multi.set_text( label_multi.get_text() + "\n All done, counter = %d" % counter)