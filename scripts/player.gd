extends CharacterBody3D
class_name Player

@onready var anim = $AnimatedSprite3D

@onready var all_interactions = []
@onready var InteractLabel = $InteractionComponents/InteractLabel


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	# Why: Group-based filtering keeps interact logic generic.
	if not is_in_group("player"):
		add_to_group("player")
	print("Player Exists") 
	
	update_interactions()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed("Interact"):
		execute_interaction()
	
	#Animations
	if is_on_floor():  #it means the character is either idle, running or sprinting
		if velocity.x == 0:
			anim.play("idle")
		else:
			if Input.is_action_pressed("move_left"):
				$AnimatedSprite3D.flip_h = true
				anim.play("walk")
			if Input.is_action_pressed("move_right"):
				$AnimatedSprite3D.flip_h = false
				anim.play("walk")
			if Input.is_action_pressed("move_backward"):
				anim.play("walk")
			if Input.is_action_pressed("move_forward"):
				anim.play("walk")
			else:
				anim.play("walk")
	else: #it means the character is either jumping or falling
		if velocity.y <= 0:
			anim.play("jump")
		else:
			anim.play("fall")
	
	move_and_slide()
	

#Interactions

func _on_interaction_area_area_entered(area: Area3D) -> void:
	all_interactions.insert(0, area)
	update_interactions()

func _on_interaction_area_area_exited(area: Area3D) -> void:
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		InteractLabel.text = all_interactions[0].interact_value
	else:
		InteractLabel.text = ""

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"scene_change" :
				print (cur_interaction.interact_value)
				Global.playerposition = self.global_transform
				Global.lastscene = cur_interaction.last_scene
				if cur_interaction.entrance == true:
					Global.scenepath.append(Global.lastscene)
					Global.coordinates.append(Global.playerposition)
				else:
					Global.scenepath.pop_back()
					Global.coordinates.pop_back()
				#print(Global.playerposition)
				#print(Global.lastscene)
				print(Global.scenepath)
				print(Global.coordinates)
				get_tree().change_scene_to_file(cur_interaction.interact_target)
				
