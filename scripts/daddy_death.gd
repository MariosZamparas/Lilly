extends Node3D
@onready var anim_idle = $AnimatedSprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_idle.play("idle")
