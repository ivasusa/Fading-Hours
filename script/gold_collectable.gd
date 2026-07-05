extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fall()
	
func fall():
	$AnimationPlayer.play("falling_from_well")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("fade")
	print("+1 gold coin")
	Global.has_coin = true  
	await get_tree().create_timer(0.3).timeout
	queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
