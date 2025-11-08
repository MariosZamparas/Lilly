extends Control

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func resume() -> void:
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause() -> void:
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func escape() -> void:
	if Input.is_action_just_pressed("Options") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Options") and get_tree().paused == true:
		resume()



func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _process(_delta: float) -> void:
	escape()
