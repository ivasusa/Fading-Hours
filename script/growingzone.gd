extends StaticBody2D

var plant=Global.plant_selected
var plant_growing=false
var plant_grown=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if plant_growing==false:
		plant=Global.plant_selected


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not plant_growing:
		if plant==1:
			plant_growing=true
			$carrotTimer.start()
			$plant.play("carrotgrowing")
	else:
		print("plant is growing")		
		


func _on_carrot_timer_timeout() -> void:
	var carrot_plant=$plant
	if carrot_plant.frame==0:
		carrot_plant.frame=1
		$carrotTimer.start()
	elif carrot_plant.frame==1:
		carrot_plant.frame=2
		plant_grown=true
		
		 	
		


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		if plant_grown:
			if plant==1:
				Global.num_of_carrots+=1
				plant_growing=false
				plant_grown=false
				print("prebacujem na none")
				$plant.visible=false
				print("number of carrots" + str(Global.num_of_carrots))				
			else:
				pass
	
				
