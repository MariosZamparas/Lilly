extends Area3D
class_name InteractionArea
## Minimal interaction carrier. Place on doors/items/NPCs.
# Current Interaction types:
#1. scene_change: is either an entrance or an exit, and is used to change location for the player/
#2. item_pickup: used for any item that they player picks up
#3. scene_change_locked: same as scene_change, but the player needs a key in order to enter
#4. camera_change: used to change the active camera within the same scene

#General Interaction Info
@export_enum("scene_change", "item_pickup", "scene_change_locked", "camera_change", "chunk_spawn") var interaction_type: String
@export var int_text: String = "" #The text to be displayed on top of the player (if neccessary)
@export var trigger: bool = false #trigger to determine if the interaction should happen with a button press or by entering the area



#For the scene_change interactions
@export_file("*.tscn") var target_file: String = ""
@export var enter: bool = true  # true = entering a place, false = exiting

#For the item_pickup interactions
@export var item_type: InvItem

#For a trigger camera change
@export var next_camera: Camera3D

#Varaibles for the chunk spawner
@onready var chunk1: PackedScene = preload("res://Scenes/chunk_1.tscn")
@onready var scene: Node = get_parent()
@export var chunk_offset: Vector3

func spawn_next_chunk() -> void:
	# Instantiate the packed scene and add the resulting Node to the parent.
	var inst = chunk1.instantiate()
	var inst_position: Vector3
	if not inst:
		push_error("spawn_next_chunk: failed to instantiate chunk scene")
		return

	var parent_node = scene if scene else get_parent()
	if parent_node:
		parent_node.add_child(inst)
		inst_position = self.global_position + chunk_offset
		inst_position.y = 0
		inst_position.z = 0
		inst.translate(inst_position)
		SaveState.push_chunk(inst)
		self.queue_free()
	else:
		push_error("spawn_next_chunk: no parent to add chunk to")
