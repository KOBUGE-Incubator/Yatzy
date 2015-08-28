
extends Control

var dice_rolled = false
var option_pressed = false
var confirm_pressed = false
var dice_value
var sum_of_six = [0,0,0,0,0,0] # current dice values
var sum_of_all = [0,0,0,0,0,0,0,0,0,0,0,0,0] # current option values
var total_sum = 0 # current dice sum
var sum_of_points = [0,0,0,0,0,0,0,0,0,0,0,0,0] # chosen option values
var total_points = 0 # chosen option sum
var single_values = range(1,7)
var active_option = -1
var zero_amount
var index = 0
var played_round = 0
var bonus # bonus points if options 1-6 give 63 or more points
var check_bonus = 0 # tells whether bonus has to be checked or not

func _ready():
	# add same signal to all options
	for x in get_children():
		x.connect("pressed",self,"_on_option_pressed")
	pass

func _process(delta):
	if option_pressed == true:
		option_pressed = false
		var index = -1
		for child in get_children(): # iterate through all options
			index += 1
			if child.is_pressed():
				if index != active_option:
					if active_option != -1:
						get_child(active_option).set_pressed(false)
					active_option = index
					break
	
	if confirm_pressed == true:
		confirm_pressed = false
		played_round += 1 # count amount of played rounds
		if active_option != -1 and get_child(active_option).is_pressed():
			# deselect and disable chosen option
			get_child(active_option).set_pressed(false)
			get_child(active_option).set_disabled(true)
			# safe chosen points, calculate total and change total label
			calc_bonus()
			sum_of_points[active_option] = sum_of_all[active_option]
			print("total ",total_points," + new ",sum_of_all[active_option])
			total_points += sum_of_all[active_option]
			get_node("../Total").set_text(str("Total: ",total_points))
			# reset dices and attempts and start a new dice roll
			if played_round < 13:
				get_node("../../Control").attempts = 3
				get_node("../../Control").dice_reset = true
				get_node("../../Control").dice_rolled = true
				get_node("../../Control").set_process(true)
	
	if dice_rolled == true:
		dice_rolled = false
		dice_value = get_node("../../Control").dice_value
		sum_of_six = [0,0,0,0,0,0]
		
		# 1,2,3,4,5,6,triple,quadruple,fullHouse,smallStraight,largeStraight,yahtzee,chance
		sum_of_all = [0,0,0,0,0,0,0,0,0,0,0,0,0]
		total_sum = 0
		
		# sum up single values and total value of all dices
		for value in dice_value:
			sum_of_six[value-1] += value
			total_sum += value
		
		# check for "three of a kind" and "four of a kind"
		for index in range(6):
			sum_of_all[index] = sum_of_six[index]
			if sum_of_six[index] >= single_values[index]*3:
				sum_of_all[6] = total_sum # triple
			if sum_of_six[index] >= single_values[index]*4:
				sum_of_all[7] = total_sum # quadruple
			index += 1
		
		# check for other special options
		zero_amount = count_zero(sum_of_six)
		if zero_amount == 1 and (sum_of_six[0] == 0 or sum_of_six[5] == 0):
			sum_of_all[10] = 40 # large straight
			sum_of_all[9] = 30 # small straight
		elif zero_amount == 1 and (sum_of_six[1] == 0 or sum_of_six[4] == 0):
			sum_of_all[9] = 30 # small straight
		elif zero_amount == 2 and ((sum_of_six[0] == 0 and sum_of_six[1] == 0) or
		(sum_of_six[0] == 0 and sum_of_six[5] == 0) or
		(sum_of_six[4] == 0 and sum_of_six[5] == 0)):
			sum_of_all[9] = 30 # small straight
		elif zero_amount == 4 and sum_of_all[7] == 0:
			sum_of_all[8] = 25 # full house
		elif zero_amount == 5:
			sum_of_all[11] = 50 # yahtzee
		
		sum_of_all[12] = total_sum # chance
		
		# change labels to show current points
		index = 0
		for child in get_children():
			if not child.is_disabled():
				child.get_child(0).set_text(var2str(sum_of_all[index]))
			index += 1
		
		calc_bonus()

	
	set_process(false)

func count_zero(array):
	var count = 0
	for x in array:
		if x == 0:
			count += 1
	return count

func calc_bonus():
	# check bonus (options 1-6 give >= 63 points) and change label if needed
	bonus = 0
	if check_bonus < 6:
		check_bonus = 0
		for x in range(6):
			if get_child(x).is_disabled() == true:
				bonus += sum_of_points[x]
				check_bonus += 1
			else:
				bonus += sum_of_all[x]
		if bonus >= 63:
			get_node("../Bonus/Label").set_text("35")
		else:
			get_node("../Bonus/Label").set_text("0")
		# add bonus if unlocked 
		if check_bonus == 6:
			print("check bonus + 35")
			total_points += 35

func _on_option_pressed():
	option_pressed = true
	set_process(true)

func _on_confirm_pressed():
	confirm_pressed = true
	set_process(true)
