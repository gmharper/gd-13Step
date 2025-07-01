extends PanelContainer

signal space_pressed(index:int, space:Node)
signal space_released(index:int, space:Node)
signal space_mouse_entered(index:int, space:Node)
signal space_mouse_exited(index:int, space:Node)

@export var row:String
@export var index:int
@onready var filled:bool = false
@onready var tile:String = '' 			##'single', 'double', 'triple', 'corner', 'cross'
@onready var orientation:String = ''
##'top', 'left', 'bottom', 'right'	if tile == 'single'
##'vertical', 'horizontal'			if tile == 'double'
##'top', 'left', 'bottom', 'right'	if tile == 'triple'
##'top', 'left', 'bottom', 'right'	if tile == 'corner'

@export var left:Node
@export var top:Node
@export var right:Node
@export var bottom:Node

## white_connection, white_border, black_connection, black_border, white_wall, black_wall, null
@onready var leftFilled:String
@onready var topFilled:String
@onready var rightFilled:String
@onready var bottomFilled:String

func clear_paint () -> void: ## paint is for visual represntation of a space
	self.modulate = Color(1,1,1,1)
	return
	
func paint(colour: String) -> void:
	match colour:
		'red':
			self.modulate.r = 255
			self.modulate.g = 0
			self.modulate.b = 0
		'blue':
			self.modulate.r = 0
			self.modulate.g = 255
			self.modulate.b = 255
		'green':
			return
	return
	
func clear_space () -> void:
	$Tile.visible = false
	
	self.filled = false
	
	self.leftFilled = ''
	self.topFilled = ''
	self.rightFilled = ''
	self.bottomFilled = ''
	
	self.tile = ''
	self.orientation = ''

	
func show_tile(tileType:String) -> void:
	if tileType:
		clear_space()
		self.filled = true
		self.tile = tileType
		$Tile/TileTexture.texture = load("res://src/assets/tiles/" +tileType +Globals.tileScheme +".jpg")
		$Tile.visible = true

func fill_border (left:String, top:String, right:String, bottom:String) -> void:
	self.leftFilled = left
	self.topFilled = top
	self.rightFilled = right
	self.bottomFilled = bottom
	%debug_fillLeft.text = left
	%debug_fillTop.text = top
	%debug_fillRight.text = right
	%debug_fillBot.text = bottom
	%debug_fillLeft.visible = true
	%debug_fillTop.visible = true
	%debug_fillRight.visible = true
	%debug_fillBot.visible = true
	
	

func place_tile(tileType:String, orientation:String) -> void:
	show_tile(tileType)
	self.orientation = orientation
	
	var connection:String = 'white_connection' if tileType.contains('white') else \
							'black_connection' if tileType.contains('black') else ''
	
	var border:String = 'white_border' if tileType.contains('white') else \
						'black_border' if tileType.contains('black') else ''
						
	var wall:String = 'white_wall' if tileType.contains('white') else \
						'black_wall' if tileType.contains('black') else ''
	
	match tileType:
		'single_white', 'single_black':
			match orientation:
				'left':
					fill_border(connection, border, border, border)
					self.rotation_degrees = 270
				'top':
					fill_border(border, connection, border, border)
					self.rotation_degrees = 0
				'right':
					fill_border(border, border, connection, border)
					self.rotation_degrees = 90
				'bottom':
					fill_border(border, border, border, connection)
					self.rotation_degrees = 180
					
		'double_white', 'double_black':
			match orientation:
				'vertical':
					fill_border(border, connection, border, connection)
					self.rotation_degrees = 0
				'horizontal':
					fill_border(connection, border, connection, border)
					self.rotation_degrees = 90
					
		'triple_white', 'triple_black':
			match orientation:
				'left':
					fill_border(connection, connection, border, connection)
					self.rotation_degrees = 270
				'top':
					fill_border(connection, connection, connection, border)
					self.rotation_degrees = 0
				'right':
					fill_border(border, connection, connection, connection)
					self.rotation_degrees = 90
				'bottom':
					fill_border(connection, border, connection, connection)
					self.rotation_degrees = 180
			
		'corner_white', 'corner_black':
			match orientation:
				'left':
					fill_border(connection, connection, border, border)
					self.rotation_degrees = 270
				'top':
					fill_border(border, connection, connection, border)
					self.rotation_degrees = 0
				'right':
					fill_border(border, border, connection, connection)
					self.rotation_degrees = 90
				'bottom':
					fill_border(connection, border, border, connection)
					self.rotation_degrees = 180
			
		'cross_white', 'cross_black':
			fill_border(connection, connection, connection, connection)
			self.rotation_degrees = 0
		
		'tower_white', 'tower_black':
			fill_border(wall, wall, wall, wall)
			self.rotation_degrees = 0


## SIGNALS
func _on_mouse_entered() -> void:
	Globals.validSpace = true
	Globals.validBoardSpace = true
	Globals.activeIndex = self.row + str(self.index)
	$WhiteOutline.visible = true
	space_mouse_entered.emit(self.index, self)

func _on_mouse_exited() -> void:
	Globals.validSpace = false
	Globals.validBoardSpace = false
	Globals.activeIndex = ''
	$WhiteOutline.visible = false
	space_mouse_exited.emit(self.index, self)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and (event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed()):
		space_pressed.emit(index, self)
		$GreenOutline.visible = true
		
	if event is InputEventMouseButton \
	and (event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_released()):
		space_released.emit(index, self)	
		$GreenOutline.visible = false
