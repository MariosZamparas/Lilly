extends Resource

class_name Inv

@export var items: Array[InvItem]

# Return true if there are no non-empty items in the inventory.
func is_empty() -> bool:
	for it in items:
		if it:
			return false
	return true

# Remove the item at the given index (clear the slot). Safe to call
# even if the index is out of range.
func remove_item(index: int) -> void:
	if index >= 0 and index < items.size():
		items[index] = null
