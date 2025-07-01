extends PanelContainer


func set_and_show(tileType:String, orientation:String) -> void:
	$GhostTileTexture.texture = load("res://src/assets/tiles/" +tileType +Globals.tileScheme +".jpg")
	set_orientation(orientation)
	self.position = get_global_mouse_position() + Vector2(-25, -25)
	self.visible = true


func set_orientation(orientation:String) -> void:
	match orientation:
		'':
			self.rotation_degrees = 0
		'left':
			self.rotation_degrees = 270
		'top':
			self.rotation_degrees = 0
		'right':
			self.rotation_degrees = 90
		'bottom':
			self.rotation_degrees = 180
		'vertical':
			self.rotation_degrees = 0
		'horizontal':
			self.rotation_degrees = 90

	
func clear() -> void:
	self.visible = false
	self.rotation_degrees = 0
	return
