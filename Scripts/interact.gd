extends Area3D
class_name InteractionArea
## Minimal interaction carrier. Place on doors/items/NPCs.

@export var interaction_type: StringName = &""
@export var int_text: String = ""


#For the scene_change interactions
@export_file("*.tscn") var target_file: String = ""
@export var enter: bool = true  # true = entering a place, false = exiting

#For the item_pickup interactions
@export var item_type: InvItem
