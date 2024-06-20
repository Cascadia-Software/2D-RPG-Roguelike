extends Control

func _process(_delta):
	menuButton()

func menuButton():
	if Input.is_action_just_pressed("menu") and get_tree().paused == false:
			show()
			get_tree().paused = true
	elif Input.is_action_just_pressed("menu") and get_tree().paused == true:
			get_tree().paused = false
			hide()

func _on_resume_pressed():
	get_tree().paused = false
	hide()

func _on_restart_pressed():
	get_tree().paused = false
	hide()
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
