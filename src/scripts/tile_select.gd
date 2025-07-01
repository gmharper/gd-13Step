extends PanelContainer

signal tile_pressed(type, colour, node)
signal tile_released(type, colour, node)

@export var tileType:String
@export var tileColour:String

func _ready() -> void:
	set_texture(tileType)

## UTILITY
func set_texture(type:String) -> void:
	$TileSelectTexture.texture = load("res://src/assets/tiles/"+ type + Globals.tileScheme + ".jpg")
	
func showhide_white_outline(showhide:bool) -> void:
	$WhiteOutline.visible = showhide

func showhide_green_outline(showhide:bool) -> void:
	$GreenOutline.visible = showhide
	
	
## SIGNALS
func _on_mouse_entered() -> void:
	Globals.validSpace = true
	$WhiteOutline.visible = true
	
func _on_mouse_exited() -> void:
	Globals.validSpace = false
	$WhiteOutline.visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and (event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed()):
		tile_pressed.emit(self.tileType, self.tileColour, self)
		
	if event is InputEventMouseButton \
	and (event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_released()):
		tile_released.emit(self.tileType, self.tileColour, self)
