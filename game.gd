
extends Control

var dice_pressed = false
var dice_rolled = false
var dice_reset = false
var dice_status = [0,0,0,0,0]
var dice_value = [0,0,0,0,0]
var dice_index = 0
var chosen_option = ""
var option_pressed = false
var option_values = range(13)
var attempts = 3

func _ready():
	randomize()
	dice_rolled = true
	set_process(true)
	pass

func _process(delta):
	
	# make attempt symbols visible after reset
	if attempts > 1:
		get_node("play dice/attempt1").show()
		get_node("play dice/attempt2").show()
		
	if dice_reset == true:
		dice_reset = false
		for child in range(5):
			if dice_status[child] == 1:
				get_node(str("dice",child,"/back")).set_modulate(Color(1,1,1,1))
				dice_status[child] = 0
	
	if dice_pressed == true:
		dice_pressed = false
		if Color(1,1,1,1) == get_node(str("dice",dice_index,"/back")).get_modulate():
			get_node(str("dice",dice_index,"/back")).set_modulate(Color(1,0,0,1))
		else:
			get_node(str("dice",dice_index,"/back")).set_modulate(Color(1,1,1,1))
		
		if dice_status[dice_index] == 0:
			dice_status[dice_index] = 1
		else:
			dice_status[dice_index] = 0
	
	if dice_rolled == true:
		dice_rolled = false
		dice_index = -1
		if attempts > 0:
			for status in dice_status:
				dice_index += 1
				if status == 0:
					dice_value[dice_index] = (randi() % 6) + 1
					get_node("dice"+var2str(dice_index)+"/number").set_frame(dice_value[dice_index])
			attempts -= 1
			if attempts == 1:
				get_node("play dice/attempt1").hide()
			elif attempts == 0:
				get_node("play dice/attempt2").hide()
		
			get_node("Choose").set("dice_rolled",true)
			get_node("Choose").set_process(true)
	
	
	set_process(false)

func _on_play_dice_pressed():
	dice_rolled = true
	set_process(true)

func _on_dice0_pressed():
	dice_pressed = true
	dice_index = 0
	set_process(true)


func _on_dice1_pressed():
	dice_pressed = true
	dice_index = 1
	set_process(true)


func _on_dice2_pressed():
	dice_pressed = true
	dice_index = 2
	set_process(true)


func _on_dice3_pressed():
	dice_pressed = true
	dice_index = 3
	set_process(true)


func _on_dice4_pressed():
	dice_pressed = true
	dice_index = 4
	set_process(true)



