extends Control

func _on_start_pressed() -> void:
	print("start pressed")
	get_tree().change_scene_to_file("res://scenes/demo.tscn")

func _on_options_pressed() -> void:
	print("options pressed")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_2nd_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/inside_building.tscn")
