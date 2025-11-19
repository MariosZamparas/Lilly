extends Node

# Single array where each entry pairs a chunk instance with its offset.
# Each element is a Dictionary: {'chunk': Node3D, 'offset': Vector3}
var chunks: Array[Dictionary] = []

func push_chunk(chunk: Node3D) -> void:
	var info := {
		'chunk': chunk,
		'offset': chunk.global_position
	}
	chunks.push_back(info)
	print("chunk and chunk coords pushed")

# Return the chunk instance that was last pushed, or null if none.
func pop_chunk() -> Node3D:
	if chunks.is_empty():
		return null
	var info = chunks.pop_back()
	return info.get('chunk', null)

func has_chunks() -> bool:
	return not chunks.is_empty()

# Convenience: get the offset for the last pushed chunk (or Vector3.ZERO).
func last_chunk_offset() -> Vector3:
	if chunks.is_empty():
		return Vector3.ZERO
	var info = chunks.back()
	return info.get('offset', Vector3.ZERO)


func load_chunks(parent_scene: Node) -> Dictionary:
	# parent_scene: the scene (Node) under which chunk instances should be placed.
	# This function will either reparent stored Node instances (if the saved
	# info contains a live Node) or instantiate a PackedScene if a scene path
	# or PackedScene reference is available in the saved info.
	var spawned: Array[Node3D] = []

	if not has_chunks():
		return {'instances': spawned}

	if not parent_scene:
		return {'instances': spawned}

	for info in chunks:
		var inst: Node3D = null

		# Case A: saved a live Node reference under 'chunk'
		if info.has('chunk') and info['chunk'] and info['chunk'] is Node3D:
			inst = info['chunk'] as Node3D
			# Reparent into the provided parent_scene (this will move it if needed)
			parent_scene.add_child(inst)
			inst.global_position = info.get('offset', Vector3.ZERO)

		# Case B: saved a PackedScene object under 'packed_scene'
		elif info.has('packed_scene') and info['packed_scene'] and info['packed_scene'] is PackedScene:
			var ps: PackedScene = info['packed_scene'] as PackedScene
			var tmp := ps.instantiate()
			if tmp and tmp is Node3D:
				inst = tmp as Node3D
				parent_scene.add_child(inst)
				inst.global_position = info.get('offset', Vector3.ZERO)

		# Case C: saved a scene path under 'scene_path' (string)
		elif info.has('scene_path') and info['scene_path']:
			var path = info['scene_path']
			var ps2 = ResourceLoader.load(path) as PackedScene
			if ps2:
				var tmp2 := ps2.instantiate()
				if tmp2 and tmp2 is Node3D:
					inst = tmp2 as Node3D
					parent_scene.add_child(inst)
					inst.global_position = info.get('offset', Vector3.ZERO)

		# If we have a spawned instance, add to result list
		if inst:
			spawned.append(inst)

	return {'instances': spawned}
