extends Area3D
class_name InteractionArea
## Minimal interaction carrier. Place on doors/items/NPCs.
# Current Interaction types:
#1. scene_change: is either an entrance or an exit, and is used to change location for the player/
#2. item_pickup: used for any item that they player picks up
#3. scene_change_locked: same as scene_change, but the player needs a key in order to enter
#4. camera_change: used to change the active camera within the same scene

@export var interaction_type: StringName = &""
@export var int_text: String = ""


#For the scene_change interactions
@export_file("*.tscn") var target_file: String = ""
@export var enter: bool = true  # true = entering a place, false = exiting

#For the item_pickup interactions
@export var item_type: InvItem

#For a trigger camera change
@export var trigger: bool = false
#@export var current_camera: Camera3D
@export var next_camera: Camera3D
#var was_triggered: bool = false
