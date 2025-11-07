#https://www.youtube.com/watch?v=X3J0fSodKgs

extends Control

@onready var inv: Inv = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false
var immidiate: bool

func _ready() -> void:
	update_slots()
	close()
	immidiate = false
	$AnimationPlayer.play("RESET")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		if is_open == true and get_tree().paused == true:
			close()
		elif is_open == false and get_tree().paused == false:
			open()
			update_slots() 
		

func open():
	self.visible = true
	is_open = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func close(immediate := false):
	is_open = false
	get_tree().paused = false
	if immediate:
		visible = false
	else:
		$AnimationPlayer.play_backwards("blur")
		await $AnimationPlayer.animation_finished
		visible = false
	
func update_slots() -> void:
	# Update every slot. If there is no item for a slot, pass null to clear it.
	for i in range(slots.size()):
		var item = null
		if i < inv.items.size():
			item = inv.items[i]
		# Call the panel's set_item() (renamed from update to avoid clashing
		# with the engine's builtin update()).
		slots[i].set_item(item)
