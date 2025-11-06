extends TextureRect

@onready var item_visual: Sprite2D = $item_display

# Renamed from `update` to `set_item` to avoid clashing with the
# built-in Control/CanvasItem.update() method which takes no arguments.
func set_item(item: InvItem) -> void:
	if not item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
