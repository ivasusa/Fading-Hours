extends Node2D

var state="no water" #also water
var player_in_area=false
var gold=preload("res://scene/gold_collectable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state=="no water":
		$growthTimer.start()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state=="no water":
		$AnimatedSprite2D.play("well_empty")
	if state=="water":
		$AnimatedSprite2D.play("well")
	if player_in_area==true:
		if Input.is_action_just_pressed("e"):
			state="no water"
			drop_gold()

func _on_pickable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area=true


func _on_pickable_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area=false


func _on_growth_timer_timeout() -> void:
	if state=="no water":
		state="water"

func drop_gold():
	var gold_instance=gold.instantiate()
	gold_instance.global_position=$Marker2D.global_position
	get_parent().add_child(gold_instance)
	
	await get_tree().create_timer(3).timeout
	$growthTimer.start()
		
