extends CharacterBody3D

@onready var anim: AnimatedSprite3D = $AnimatedSprite3D
@onready var interact_label: Label3D = $Interaction/Label3D
@onready var interactions_area: Area3D = $Interaction/Area3D # child's signals should be connected to the _on_* callbacks
@onready var item_label: Label3D = $Interaction/ItemLabel
@onready var text_anim: AnimationPlayer = $Interaction/ItemLabel/item_text_anim

@export var inv: Inv

var all_interactions: Array[Area3D] = []

const SPEED := 5.0
const JUMP_VELOCITY := 4.5

func _ready() -> void:
	interact_label.text = ""
	item_label.text = ""
	text_anim.play("RESET")
	if Global.spawn_from_stack and Global.has_positions():
		global_position = Global.pop_position()
		Global.spawn_from_stack = false

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var input_dir := Input.get_vector("Left", "Right", "Backwards", "Forwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)

	# Interact
	if Input.is_action_just_pressed("Interact"):
		execute_interaction()

	move_and_slide()

#region Animations
	# Animations
	if is_on_floor():
		if absf(velocity.x) < 0.001 and absf(velocity.z) < 0.001:
			anim.play("Idle")
		else:
			$AnimatedSprite3D.flip_h = Input.is_action_pressed("Left") and not Input.is_action_pressed("Right")
			anim.play("Run")
	else:
		anim.play("Jump" if velocity.y <= 0.0 else "Fall")  
#endregion


#region Interactions
# ---- Interaction handling ----
func _on_area_3d_area_entered(area: Area3D) -> void:
	all_interactions.insert(0, area)
	_update_interactions_label()
	
	if (all_interactions[0] as InteractionArea).trigger == true:
		execute_interaction()

func _on_area_3d_area_exited(area: Area3D) -> void:
	all_interactions.erase(area)
	_update_interactions_label()

func _update_interactions_label() -> void:
	if all_interactions.size() > 0 and all_interactions[0] is InteractionArea:
		interact_label.text = (all_interactions[0] as InteractionArea).int_text
	else:
		interact_label.text = ""

func execute_interaction() -> void:
	if all_interactions.is_empty():
		return

	var cur := all_interactions[0]
	if not (cur is InteractionArea):
		return
		
	match (cur as InteractionArea).interaction_type:
		"scene_change":
			if (cur as InteractionArea).enter:
				#Going inside: remember current outside position; next spawn is default (no stack pop).
				Global.push_position(global_position)
				Global.spawn_from_stack = false
				SceneSwitch.switch_scene((cur as InteractionArea).target_file)
			else:
				# Leaving: next player instance should spawn from the last saved position.
				Global.spawn_from_stack = true
				SceneSwitch.switch_scene((cur as InteractionArea).target_file)
				
				#if ((cur as InteractionArea).target_file) == "res://Scenes/Scene1.tscn":
					#print("Scene Identified")
					#var scene_root = (cur as InteractionArea).target_file
					#SaveState.load_chunks(scene_root)
					
		"item_pickup":
			pickup_item((cur as InteractionArea).item_type, inv)
		"scene_change_locked":
			var has_key: bool = check_for_key()
			
			if has_key == false:
				interact_label.text = "This door is locked!"
			elif  has_key == true:
				if (cur as InteractionArea).enter:
					# Going inside: remember current outside position; next spawn is default (no stack pop).
					Global.push_position(global_position)
					Global.spawn_from_stack = false
					SceneSwitch.switch_scene((cur as InteractionArea).target_file)
				else:
					# Leaving: next player instance should spawn from the last saved position.
					Global.spawn_from_stack = true
					SceneSwitch.switch_scene((cur as InteractionArea).target_file)
		"camera_change":
			(cur as InteractionArea).next_camera.make_current()
		"chunk_spawn":
			print ("chunk_spawn initiated")
			(cur as InteractionArea).spawn_next_chunk()


func pickup_item(item: InvItem, player_inv: Inv = null) -> void:
	# If no inventory provided, use the player's exported one.
	if player_inv == null:
		player_inv = inv

	if not player_inv:
		push_error("pickup_item: no inventory provided")
		return

	# Iterate indices of the inventory's items array and place the item
	# into the first empty slot (nil / falsy). If none found, inventory is full.
	for i in range(player_inv.items.size()):
		if not player_inv.items[i]:
			player_inv.items[i] = item
			player_inv.items[i] = item
			item_label.text = "Picked up: %s" % item.name
			print("item added")
			text_anim.play("fade")
			return
		else:
			print("Inventory full")
			item_label.text= "Bag Full!"
			text_anim.play("fade")

func check_for_key(player_inv: Inv = null) -> bool:
	if player_inv == null:
		player_inv = inv
	
	if not player_inv:
		push_error("pickup_item: no inventory provided")
		return false
	
	for i in range(player_inv.items.size()):
		var it = player_inv.items[i]
		if it and it.name == "key":
			player_inv.remove_item(i)
			return true

	# Not found
	return false
#endregion
