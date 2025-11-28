extends Node
## Session-wide state for player spawn stack.

var position_stack: Array[Vector3] = []
var spawn_from_stack: bool = false  # set true when leaving an interior

func push_position(p: Vector3) -> void:
	position_stack.push_back(p)

func pop_position() -> Vector3:
	if position_stack.is_empty():
		return Vector3.ZERO
	return position_stack.pop_back()

func has_positions() -> bool:
	return not position_stack.is_empty()
