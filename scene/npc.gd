extends CharacterBody2D

const SPEED = 30
var dir=Vector2.RIGHT
var start_pos
var current_state=IDLE
var is_roaming=true
var is_chatting=false
var player
var player_in_chat_zone=false
var dialog_instance=null
var short_dialog_done=false
var waiting_for_input=false
enum{IDLE,NEW_DIR,MOVE}

func _ready():
	randomize()
	start_pos=position

func get_dialog_file():
	if (Global.has_photo and Global.has_coin and not Global.talked_to_fisherman_long) or (Global.talked_to_fisherman_long and Global.has_photo):
		return "res://dialog/npcWorker_return.json"
	else:
		return "res://dialog/npcWorker.json"

func _on_dialog_finished():
	if !short_dialog_done:
		short_dialog_done=true
		is_chatting=true
		waiting_for_input=false
		return
	Global.has_fish=true
	is_chatting=false
	dialog_instance=null
	short_dialog_done=false
	waiting_for_input=false

func _on_long_dialog_finished():
	Global.has_fish=true
	Global.talked_to_fisherman_long=true
	is_chatting=false
	dialog_instance=null
	short_dialog_done=false
	waiting_for_input=false

func _on_return_dialog_finished():
	Global.returned_to_fisherman=true
	is_chatting=false
	dialog_instance=null

func _process(delta):
	if is_chatting:
		$AnimatedSprite2D.play("idle")
		
		if short_dialog_done:
			waiting_for_input=true
			if waiting_for_input and Input.is_action_just_pressed("ui_select"):
				short_dialog_done=false
				waiting_for_input=false
				dialog_instance=preload("res://dialog/dialog.tscn").instantiate()
				dialog_instance.d_file="res://dialog/npcWorker_long.json"
				add_child(dialog_instance)
				dialog_instance.dialog_finished.connect(_on_long_dialog_finished)
				dialog_instance.start()
			elif waiting_for_input and Input.is_action_just_pressed("ui_accept"):
				Global.has_fish=true
				is_chatting=false
				short_dialog_done=false
				waiting_for_input=false
		return

	if current_state==IDLE or current_state==NEW_DIR:
		$AnimatedSprite2D.play("idle")
	elif current_state==MOVE:
		if dir.x==-1:
			$AnimatedSprite2D.play("walk_w")
		if dir.x==1:
			$AnimatedSprite2D.play("walk_e")
		if dir.y==-1:
			$AnimatedSprite2D.play("walk_n")
		if dir.y==1:
			$AnimatedSprite2D.play("walk_s")

	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir=choose([Vector2.RIGHT,Vector2.UP,Vector2.LEFT,Vector2.DOWN])
			MOVE:
				move(delta)

	if player_in_chat_zone and Input.is_action_just_pressed("chat"):
		is_roaming=false
		var file = get_dialog_file()
		dialog_instance=preload("res://dialog/dialog.tscn").instantiate()
		dialog_instance.d_file=file
		add_child(dialog_instance)
		if file == "res://dialog/npcWorker_return.json":
			dialog_instance.dialog_finished.connect(_on_return_dialog_finished)
		else:
			dialog_instance.dialog_finished.connect(_on_dialog_finished)
		dialog_instance.start()
		is_chatting=true

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position+=dir*SPEED*delta
		if position.distance_to(start_pos)>100:
			dir=(start_pos-position).normalized()

func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	print("npc detektovao: ", body.name)
	if body.has_method("player"):
		print("player detektovan!")
		player=body
		player_in_chat_zone=true
		is_roaming=false
		current_state=IDLE

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat_zone=false
		is_roaming=true

func _on_timer_timeout() -> void:
	$Timer.wait_time=choose([0.5,1,1.5])
	current_state=choose([IDLE,NEW_DIR,MOVE])
