extends Area3D

#func _process(delta: float) -> void:
	#if has_overlapping_bodies():
		#print(get_overlapping_bodies())
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print ("Area Exists")

func _on_interact_body_entered(body: Node3D) -> void: 
	if body.is_in_group("player"):
		print ("Entered")

func _on_interact_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print ("Exited")
