class_name Interactable extends Area3D

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"
@export var interact_target = "none"
@export var last_scene = "none"
@export var entrance = true

#func _process(delta: float) -> void:
	#if has_overlapping_bodies():
		#print(get_overlapping_bodies())
		
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print ("Area Exists")
#
#func _on_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#print ("Entered")
#
#
#func _on_body_exited(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#print ("Exited")
