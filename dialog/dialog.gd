extends Control

signal dialog_finished

@export_file("*.json") var d_file
var dialog=[]
var current_id=0

func _ready():
	visible = false

func start():
	visible = true
	dialog=load_dialog()
	current_id=-1
	next_script()
	
func load_dialog():
	var file = FileAccess.open(d_file, FileAccess.READ)
	
	if file == null:
		print("GRESKA: Ne mogu da otvorim fajl!")
		return null
	
	var text = file.get_as_text()
	text = text.strip_edges()
	
	var content = JSON.parse_string(text)
	
	if content == null:
		print("GRESKA: JSON parsing failed!")
		return null
	
	return content

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		next_script()
	
func next_script():	
	current_id += 1
	
	if current_id >= len(dialog):
		emit_signal("dialog_finished")
		queue_free() 
		return 
		
	$NinePatchRect/Name.text = dialog[current_id]['name']
	$NinePatchRect/Text.text = dialog[current_id]['text']
