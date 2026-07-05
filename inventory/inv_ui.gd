extends Control

@onready var inv:Inv=preload("res://inventory/playerinv.tres")
@onready var slots:Array=$NinePatchRect/GridContainer.get_children()
	
var is_open=false

func _ready() -> void:
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.items.size(),slots.size())):
		slots[i].update(inv.items[i])
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
		else:
			open()	

func close():
	visible=false
	is_open=false
	
func open():
	is_open=true
	visible=true	
