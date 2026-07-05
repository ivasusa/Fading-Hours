extends CharacterBody2D

var is_chatting=false
var player
var player_in_chat_zone=false
var dialog_instance=null

func _ready():
	$AnimatedSprite2D.play("idle")

func _process(_delta):
	if player_in_chat_zone and Input.is_action_just_pressed("chat"):
		print("chat pritisnut, player_in_chat_zone: ", player_in_chat_zone)
		print("is_chatting: ", is_chatting)
		if !is_chatting:
			print("pokrecemo dijalog: ", get_dialog_file())
			is_chatting=true
			dialog_instance = preload("res://dialog/dialog.tscn").instantiate()
			dialog_instance.d_file = get_dialog_file()
			add_child(dialog_instance)
			dialog_instance.dialog_finished.connect(_on_dialog_finished)
			dialog_instance.start()

func _on_dialog_finished():
	is_chatting=false
	dialog_instance=null

func _on_chat_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player=body
		player_in_chat_zone=true

func _on_chat_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat_zone=false
		is_chatting=false

func get_dialog_file():
	if Global.has_coin and Global.has_photo and Global.has_fish:
		return "res://dialog/grandma_ending_full.json"
	elif Global.has_coin and Global.has_photo and Global.talked_to_fisherman_long and Global.returned_to_fisherman:
		return "res://dialog/grandma_ending_fisherman.json"
	elif Global.has_coin and Global.has_photo and Global.talked_to_fisherman_long:
		return "res://dialog/grandma_ending_photo.json"
	elif Global.has_coin and Global.has_photo and not Global.talked_to_fisherman_long:
		return "res://dialog/grandma_needs_fisherman.json"
	elif Global.has_coin and Global.has_fish:
		return "res://dialog/grandma_after_fish.json"
	elif Global.has_coin and Global.talked_to_fisherman_long:
		return "res://dialog/grandma_after_long.json"
	elif Global.has_coin:
		return "res://dialog/grandma_after_coin.json"
	else:
		return "res://dialog/grandma_intro.json"
