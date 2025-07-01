extends PanelContainer

## SCENES

## VARIABLES
@onready var tiles:Array[Node] = [%SelectSingle, %SelectCorner, %SelectDouble, %SelectTriple, %SelectCross]
@onready var quantityLabels = [%SingleQuantity, %CornerQuantity, %DoubleQuantity, %TripleQuantity, %CrossQuantity]
@onready var quantityAmountBars = [%SingleAmountBar, %CornerAmountBar, %DoubleAmountBar, %TripleAmountBar, %CrossAmountBar]

@export var colour:String
@export var pos:String

@onready var tileQuantities:Dictionary = {
	single_quantity = 0,
	corner_quantity = 0,
	double_quantity = 0,
	triple_quantity = 0,
	cross_quantity = 0,
	wall_quantity = 0
}

func _ready() -> void:
	connect_tiles()
	return

func draw_tile_panel (pos:String, colour:String, quantities:Array) -> void:
	self.pos = pos
	if colour == 'black':
		self.colour = 'black'
		%SelectSingle.set_texture('single_black')
		%SelectCorner.set_texture('corner_black')
		%SelectDouble.set_texture('double_black')
		%SelectTriple.set_texture('triple_black')
		%SelectCross.set_texture('cross_black')
		#%SelectWall.set_texture('wall_black')
	else:
		self.colour = 'white'
		%SelectSingle.set_texture('single_white')
		%SelectCorner.set_texture('corner_white')
		%SelectDouble.set_texture('double_white')
		%SelectTriple.set_texture('triple_white')
		%SelectCross.set_texture('cross_white')
		#%SelectWall.set_texture('wall_white')
	
	%SingleAmountBar.max_value = quantities[0]
	%SingleAmountBar.value = quantities[0]
	%CornerAmountBar.max_value = quantities[1]
	%CornerAmountBar.value = quantities[1]
	%DoubleAmountBar.max_value = quantities[2]
	%DoubleAmountBar.value = quantities[2]
	%TripleAmountBar.max_value = quantities[3]
	%TripleAmountBar.value = quantities[3]
	%CrossAmountBar.max_value = quantities[4]
	%CrossAmountBar.value = quantities[4]
	#%WallAmountBar.max_value = quantities[5]
	#%WallAmountBar.value = quantities[5]
	
	%SingleQuantity.text = str(quantities[0])
	%CornerQuantity.text = str(quantities[1])
	%DoubleQuantity.text = str(quantities[2])
	%TripleQuantity.text = str(quantities[3])
	%CrossQuantity.text = str(quantities[4])
	#%WallQuantity.text = str(quantities[5])
	
	tileQuantities.single_quantity = quantities[0]
	tileQuantities.corner_quantity = quantities[1]
	tileQuantities.double_quantity = quantities[2]
	tileQuantities.triple_quantity = quantities[3]
	tileQuantities.cross_quantity = quantities[4]
	tileQuantities.wall_quantity = quantities[5]


func connect_tiles () -> void:
	for tile in tiles:
		tile.tile_released.connect(pickup_tile)

func pickup_tile (tileType:String, tileColour:String, tileNode:Node) -> void:
	reset()
	%Board.clear_paint_all()
	%Game.release_holding_tile()
	
	if (Globals.activePlayer != self.pos):
		print('not your turn!')
		return
	else:
		if Globals.holding:
			if (tileType == Globals.holdingTileType):
				return
		
		Globals.holding = true
		Globals.holdingTile = tileNode
		Globals.holdingTileType = tileType
		
		match tileType:
			'single_white', 'single_black':
				if tileQuantities.single_quantity > 0:
					Globals.holdingOrientation = 'top'
					%SelectSingle.showhide_green_outline(true)
					%SingleQuantity.text = str(tileQuantities.single_quantity - 1)
					#%SingleAmountBar
					%GhostTile.set_and_show(tileType, 'top')
				else:
					print("no more single tiles left")
			'double_white', 'double_black':
				if tileQuantities.double_quantity > 0:
					Globals.holdingOrientation = 'vertical'
					%SelectDouble.showhide_green_outline(true)
					%DoubleQuantity.text = str(tileQuantities.double_quantity - 1)
					#%DoubleAmountBar
					%GhostTile.set_and_show(tileType, 'vertical')
				else:
					print("no more double tiles left")
			'triple_white', 'triple_black':
				if tileQuantities.triple_quantity > 0:
					Globals.holdingOrientation = 'top'
					%SelectTriple.showhide_green_outline(true)
					%TripleQuantity.text = str(tileQuantities.double_quantity - 1)
					#%TripleAmountBar
					%GhostTile.set_and_show(tileType, 'top')
				else:
					print("no more triple tiles left")
			'corner_white', 'corner_black':
				if tileQuantities.corner_quantity > 0:
					Globals.holdingOrientation = 'top'
					%SelectCorner.showhide_green_outline(true)
					%CornerQuantity.text = str(tileQuantities.corner_quantity - 1)
					#%CornerAmountBar
					%GhostTile.set_and_show(tileType, 'top')
				else:
					print("no more corner tiles left")
			'cross_white', 'cross_black':
				if tileQuantities.cross_quantity > 0:
					Globals.holdingOrientation = 'top'
					%SelectCross.showhide_green_outline(true)
					%CrossQuantity.text = str(tileQuantities.cross_quantity - 1)
					#%CrossAmountBar
					%GhostTile.set_and_show(tileType, '')
				else:
					print("no more cross tiles left")
			'wall_white', 'wall_black':
				if tileQuantities.wall_quantity > 0:
					Globals.holdingOrientation = 'top'
					%SelectWall.showhide_green_outline(true)
					%WallQuantity.text = str(tileQuantities.wall_quantity - 1)
					#%CrossAmountBar
					%GhostTile.set_and_show(tileType, '')


func reduce_counter(tileType:String) -> void:
	match tileType:
		'single':
			tileQuantities.single_quantity -= 1
		'double':
			tileQuantities.double_quantity -= 1
		'corner':
			tileQuantities.corner_quantity -= 1
		'triple':
			tileQuantities.triple_quantity -= 1
		'cross':
			tileQuantities.cross_quantity -= 1
		'wall':
			tileQuantities.wall_quantity -= 1


func reset() -> void:
	%SingleQuantity.text = str(tileQuantities.single_quantity)
	%CornerQuantity.text = str(tileQuantities.corner_quantity)
	%DoubleQuantity.text = str(tileQuantities.double_quantity)
	%TripleQuantity.text = str(tileQuantities.triple_quantity)
	%CrossQuantity.text = str(tileQuantities.wall_quantity)
	
	for tile in tiles:
		tile.showhide_white_outline(false)
		tile.showhide_green_outline(false)
