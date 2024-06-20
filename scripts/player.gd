extends CharacterBody2D

var attacking: bool = false

@export var move_speed: int = 110  # px/sec
@export var melee_reach: int = 12 # px

var mouse_angle: float = 0.0 # for shorthanding purposes

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# sets animation speed based on BPM (V which is the first number here)
	$Sprites.set_speed_scale( 110.0 / 60.0 / 2.0 )
	
	# flips sprite
	if not attacking:
		if direction.x > 0:
			$Sprites.flip_h = false
		elif direction.x < 0:
			$Sprites.flip_h = true
	elif attacking: # makes sprite face direction of attack
		mouse_angle = get_angle_to(get_global_mouse_position()) # shorthand
		if mouse_angle > -1.5 and mouse_angle < 1.5:
			$Sprites.flip_h = false
		elif mouse_angle > 1.5 or mouse_angle < -1.5:
			$Sprites.flip_h = true
	
	# slows move speed while attacking
	if not attacking: velocity = direction * move_speed
	elif attacking: velocity = direction * move_speed * 0.75
	
	# plays idle & walking animations
	if direction.x == 0 and direction.y == 0:
		$Sprites.play("idle")
	else:
		$Sprites.play("run")

	move_and_slide()


func _input(event):
	# attack animations:
	if event.is_action_pressed("mainhand_use"):
		if $AttackCooldown.time_left == 0:
			attacking = true
			$AttackCooldown.start()
			get_attack_dir()
		else:
			pass
	elif Input.is_action_just_released("mainhand_use"):
		attacking = false


func _on_attack_cooldown_timeout(): # loops attack animations
	if Input.is_action_pressed("mainhand_use"):
		get_attack_dir()
		$AttackCooldown.start()
	else: 
		$"AttackCooldown".stop()


func get_attack_dir():
	mouse_angle = get_angle_to(get_global_mouse_position()) # shorthand
	$MeleeAttack.position = Vector2 ( 0.0, 0.0 ) # resets melee hitbox position
	
	# right attack
	if mouse_angle > -0.375 and mouse_angle < 0.375:
		$MeleeAttack.position.x +=  melee_reach
		$MeleeAttack/AnimationPlayer.play("s_swing_r")
	# down-right attack
	if mouse_angle > 0.375 and mouse_angle < 1.125:
		$MeleeAttack.position +=  Vector2( diag_round(melee_reach), diag_round(melee_reach) ) # rounds diagonal coords
		$MeleeAttack/AnimationPlayer.play("s_swing_dr")
		#$MeleeAttack.position += Vector2(-2,-2) # for diagonal jab adjustments
	# down attack
	if mouse_angle > 1.125 and mouse_angle < 1.875:
		$MeleeAttack.position.y +=  melee_reach
		$MeleeAttack/AnimationPlayer.play("s_swing_d")
	# down-left attack
	if mouse_angle > 1.875 and mouse_angle < 2.625:
		$MeleeAttack.position +=  Vector2( -diag_round(melee_reach), diag_round(melee_reach) ) # rounds diagonal coords
		$MeleeAttack/AnimationPlayer.play("s_swing_dl")
		$MeleeAttack.position += Vector2(2,-2) # for diagonal jab adjustments
	# left attack
	if mouse_angle > 2.625 or mouse_angle < -2.625:
		$MeleeAttack.position.x -=  melee_reach
		$MeleeAttack/AnimationPlayer.play("s_swing_l")
	# up-left attack
	if mouse_angle > -2.625 and mouse_angle < -1.875:
		$MeleeAttack.position +=  Vector2( -diag_round(melee_reach), -diag_round(melee_reach) ) # rounds diagonal coords
		$MeleeAttack/AnimationPlayer.play("s_swing_ul")
		#$MeleeAttack.position += Vector2(2,2) # for diagonal jab adjustments
	# up attack
	if mouse_angle > -1.875 and mouse_angle < -1.125:
		$MeleeAttack.position.y -=  melee_reach
		$MeleeAttack/AnimationPlayer.play("s_swing_u")
	# up-right attack
	if mouse_angle > -1.125 and mouse_angle < -0.375:
		$MeleeAttack.position +=  Vector2( diag_round(melee_reach), -diag_round(melee_reach) ) # rounds diagonal coords
		$MeleeAttack/AnimationPlayer.play("s_swing_ur")
		#$MeleeAttack.position += Vector2(-2,2) # for diagonal jab adjustments
	return


func diag_round(px_value):
	px_value *= 0.707 #  approximate of 1 / sqrt(2)
	round(px_value)
	return px_value
