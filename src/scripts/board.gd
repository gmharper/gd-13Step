extends PanelContainer

signal placement_error (message:String)

const BoardSpace = preload("res://src/scenes/BoardSpace.tscn")

@onready var helper:bool = false

@onready var boardRows = [$BoardRows/A, $BoardRows/B, $BoardRows/C, $BoardRows/D, $BoardRows/E, $BoardRows/F, $BoardRows/G, $BoardRows/H, $BoardRows/I]

@onready var Board:Array[Array] = [
		[%A1, %A2, %A3, %A4, %A5, %A6, %A7, %A8, %A9, %A10, %A11], 
		[%B1, %B2, %B3, %B4, %B5, %B6, %B7, %B8, %B9, %B10, %B11], 
		[%C1, %C2, %C3, %C4, %C5, %C6, %C7, %C8, %C9, %C10, %C11],
		[%D1, %D2, %D3, %D4, %D5, %D6, %D7, %D8, %D9, %D10, %D11],
		[%E1, %E2, %E3, %E4, %E5, %E6, %E7, %E8, %E9, %E10, %E11],
		[%F1, %F2, %F3, %F4, %F5, %F6, %F7, %F8, %F9, %F10, %F11],
		[%G1, %G2, %G3, %G4, %G5, %G6, %G7, %G8, %G9, %G10, %G11],
		[%H1, %H2, %H3, %H4, %H5, %H6, %H7, %H8, %H9, %H10, %H11],
		[%I1, %I2, %I3, %I4, %I5, %I6, %I7, %I8, %I9, %I10, %I11],
		[%J1, %J2, %J3, %J4, %J5, %J6, %J7, %J8, %J9, %J10, %J11],
		[%K1, %K2, %K3, %K4, %K5, %K6, %K7, %K8, %K9, %K10, %K11]
	]
	
func _ready() -> void:
	connect_signals()
	return
	
## UTILITY
func connect_signals() -> void:
	for row in Board:
		for rowSpace in row:
			rowSpace.space_released.connect(board_slot_released)
			rowSpace.space_mouse_entered.connect(paint_tile)
			rowSpace.space_mouse_exited.connect(clear_paint_single)
	

func fill_board () -> void:
	var rowIndex = 0
	for row in Board:
		for rowSpace in row:
			var boardSpace = BoardSpace.instantiate()
			boardRows[rowIndex].add_child(boardSpace)
		rowIndex += 1
		
func clear_tile () -> void:
	Globals.holding = false
	Globals.holdingOrientation = 'top'
	Globals.holdingTileType = ''
	%GhostTile.rotation_degrees = 0
	%GhostTile.visible = false

func calculate_valid_spaces () -> void:
	return

	
## BOARD HELPER
func clear_paint_all () -> void:
	for row in Board:
		for rowSpace in row:
			rowSpace.clear_paint()

func clear_paint_single (tileIndex:int, tileSpace:Node) -> void:
	tileSpace.clear_paint()

func paint_tile (tileIndex:int, tileSpace:Node) -> void:
	if Globals.holding:
		if Globals.move == 1 && tileIndex in [91, 92, 93, 94, 95, 96, 97, 98, 99]:
			if not is_valid_first_placement(tileSpace, Globals.holdingTileType, Globals.holdingOrientation):
				tileSpace.paint('red')
			else:
				tileSpace.paint('blue')
	
func paint_board_first_helper () -> void:
	clear_paint_all()
	for rowSpace in Board[8]:
		if Globals.holdingTileType == 'cross':
			rowSpace.paint('red')
		else:
			return
	return

func paint_board_helper () -> void:
	clear_paint_all()
	return


## VALIDATION
func is_valid_first_placement (space:Node, tileType:String, orientation:String) -> bool:
	if (Globals.activePlayer == 'bot' && space.row != 'K'):
		placement_error.emit("you must place your first tile on the first row!")
		return false
	if (Globals.activePlayer == 'top' && space.row != 'A'):
		placement_error.emit("you must place your first tile on the first row!")
		return false
	else:
		match tileType:
			'single_white', 'single_black':
				if (Globals.activePlayer == 'top' && orientation != 'top'):
					placement_error.emit("a black square must touch the top border")
					return false
				if (Globals.activePlayer == 'bot' && orientation != 'bottom'):
					placement_error.emit("a black square must touch the bottom border")
					return false
					
			'double_white', 'double_black':
				if orientation == 'horizontal':
					placement_error.emit("a black square must touch the bottom border")
					return false
					
			'triple_white', 'triple_black':
				match orientation:
					'left':
						if space.index == 1:
							placement_error.emit("a black square cannot touch the left or right-hand borders")
							return false
					'right':
						if space.index == 11:
							placement_error.emit("a black square cannot touch the left or right-hand borders")
							return false
					'top':
						if (Globals.activePlayer == 'top'):
							if (space.index == 1 || space.index == 11):
								placement_error.emit("a black square cannot touch the left or right-hand borders")
								return false
						if (Globals.activePlayer == 'bot'):
							placement_error.emit("a black square must touch the bottom border")
							return false
					'bottom':
						if (Globals.activePlayer == 'top'):
							placement_error.emit("a black square must touch the top border")
							return false
						if (Globals.activePlayer == 'bot'):
							if (space.index == 1 || space.index == 11):
								placement_error.emit("a black square cannot touch the left or right-hand borders")
								return false
								
			'corner_white', 'corner_black':
				match orientation:
					'left':
						if Globals.activePlayer == 'top':
							if space.index == 1:
								placement_error.emit("a black square cannot touch the left or right-hand borders")
								return false
						if Globals.activePlayer == 'bot':
							placement_error.emit("a black square must touch the bottom border")
							return false
					'top':
						if (Globals.activePlayer) == 'top':
							if space.index == 11:
								placement_error.emit("a black square cannot touch the left or right-hand borders")
								return false
						if Globals.activePlayer == 'bot':
							placement_error.emit("a black square must touch the bottom border")
							return false
					'right':
						if Globals.activePlayer == 'top':
							placement_error.emit("a black square must touch the top border")
							return false
						if (Globals.activePlayer) == 'bot':
							if space.index == 11:
								placement_error.emit("a black square cannot touch the left or right-hand borders")
								return false
					'bottom':
						if Globals.activePlayer == 'top':
							placement_error.emit("a black square must touch the top border")
							return false
						if Globals.activePlayer == 'bot':
							if space.index == 1:
								placement_error.emit("a black square cannot touch the left or right-hand borders")
								return false
			'cross_white', 'cross_black':
				if (space.index == 1 || space.index == 11):
					placement_error.emit("a black square cannot touch the left or right-hand borders")
					return false
	return true

func is_valid_first_placement_alt (space:Node, tileType:String, orientation:String) -> bool:
	if tileType == 'cross':
		placement_error.emit("your first tile cannot be a cross")
		print('your first tile cannot be a cross')
		return false
	else:
		if space.index not in [91, 92, 93, 94, 95, 96, 97, 98, 99]:
			placement_error.emit("you must place your first tile on the first row!")
			print('you must place your first tile on the first row!')
			return false
		else:
			match tileType:
				'single':
					match orientation:
						'top':
							return true
						'right':
							if space.index == 99:
								placement_error.emit("must not border the edge of the board with a black square")
								print('must not border the edge of the board with a black square')
								return false
							else:
								return true
						'bottom':
							placement_error.emit("must not border the edge of the board with a black square")
							print('must not border the edge of the board with a black square')
							return false
						'left':
							if space.index == 91:
								placement_error.emit("must not border the edge of the board with a black square")
								print('must not border the edge of the board with a black square')
								return false
							else:
								return true
				'double':
					match orientation:
						'vertical':
							placement_error.emit("must not border the edge of the board with a black square")
							print('must not border the edge of the board with a black square')
							return false
						'horizontal':
							if space.index == 91 || space.index == 99:
								placement_error.emit("must not border the edge of the board with a black square")
								print('must not border the edge of the board with a black square')
								return false
							else:
								return true
				'triple':
					match orientation:
						'top':
							if space.index == 91 || space.index == 99:
								placement_error.emit("must not border the edge of the board with a black square")
								print('must not border the edge of the board with a black square')
								return false
						'right':
							placement_error.emit("must not border the edge of the board with a black square")
							print('must not border the edge of the board with a black square')
							return false
						'bottom':
							placement_error.emit("must not border the edge of the board with a black square")
							print('must not border the edge of the board with a black square')
							return false
						'left':
							placement_error.emit("must not border the edge of the board with a black square")
							print('must not border the edge of the board with a black square')
							return false
				'corner':
					match orientation:
						'top':
							if space.index == 99:
								placement_error.emit("must not border the edge of the board with a black square")
								print('must not border the edge of the board with a black square')
								return false
							else:
								return true
						'left':
							if space.index == 91:
								placement_error.emit("must not border the edge of the board with a black square")
								print('must not border the edge of the board with a black square')
								return false
							else:
								return true
						'right':
							placement_error.emit("must not border the edge of the board with a black square")
							print('must not border the edge of the board with a black square')
							return false
						'bottom':
							placement_error.emit("must not border the edge of the board with a black square")
							print('must not border the edge of the board with a black square')
							return false
			return false
			

func is_valid_placement (space:Node, tileType:String, orientation:String) -> bool:
	match tileType:
		'single_white':
			match orientation:
				'left':
					if space.left && (space.left.rightFilled == 'white_connection'):
						return true
				'top':
					if space.top && (space.top.bottomFilled == 'white_connection'):
						return true
				'right':
					if space.right && (space.right.leftFilled == 'white_connection'):
						return true
				'bottom':
					if space.bottom && (space.bottom.topFilled == 'white_connection'):
						return true
		'single_black': 
			match orientation:
				'left':
					if space.left && (space.left.rightFilled == 'black_connection'):
						return true
				'top':
					if space.top && (space.top.bottomFilled == 'black_connection'):
						return true
				'right':
					if space.right && (space.right.leftFilled == 'black_connection'):
						return true
				'bottom':
					if space.bottom && (space.bottom.topFilled == 'black_connection'):
						return true
						
		'double_white':
			match orientation:
				'vertical':
					if (space.top && (space.top.bottomFilled == 'white_connection')) || \
						(space.bottom && (space.bottom.topFilled == 'white_connection')):
							return true
				'horizontal':
					if (space.left && (space.left.rightFilled == 'white_connection')) || \
						(space.right && (space.right.leftFilled == 'white_connection')):
							return true
		'double_black':
			match orientation:
				'vertical':
					if (space.top && (space.top.bottomFilled == 'black_connection')) || \
						(space.bottom && (space.bottom.topFilled == 'black_connection')):
							return true
				'horizontal':
					if (space.left && (space.left.rightFilled == 'black_connection')) || \
						(space.right && (space.right.leftFilled == 'black_connection')):
							return true
							
		'triple_white':
			match orientation:
				'left':
					if (space.bottom && (space.bottom.topFilled == 'white_connection')) || \
						(space.left && (space.left.rightFilled == 'white_connection')) || \
						(space.top && (space.top.bottomFilled == 'white_connection')):
							return true
				'top':
					if (space.left && (space.left.rightFilled == 'white_connection')) || \
						(space.top && (space.top.bottomFilled == 'white_connection')) || \
						(space.right && (space.right.leftFilled == 'white_connection')):
							return true
				'right':
					if (space.top && (space.top.bottomFilled == 'white_connection')) || \
						(space.right && (space.right.leftFilled == 'white_connection')) || \
						(space.bottom && (space.bottom.topFilled == 'white_connection')):
							return true
				'bottom':
					if (space.right && (space.right.leftFilled == 'white_connection')) || \
						(space.bottom && (space.bottom.topFilled == 'white_connection')) || \
						(space.left && (space.left.rightFilled == 'white_connection')):
							return true
		'triple_black':
			match orientation:
				'left':
					if (space.bottom && (space.bottom.topFilled == 'black_connection')) || \
						(space.left && (space.left.rightFilled == 'black_connection')) || \
						(space.top && (space.top.bottomFilled == 'black_connection')):
							return true
				'top':
					if (space.left && (space.left.rightFilled == 'black_connection')) || \
						(space.top && (space.top.bottomFilled == 'black_connection')) || \
						(space.right && (space.right.leftFilled == 'black_connection')):
							return true
				'right':
					if (space.top && (space.top.bottomFilled == 'black_connection')) || \
						(space.right && (space.right.leftFilled == 'black_connection')) || \
						(space.bottom && (space.bottom.topFilled == 'black_connection')):
							return true
				'bottom':
					if (space.right && (space.right.leftFilled == 'black_connection')) || \
						(space.bottom && (space.bottom.topFilled == 'black_connection')) || \
						(space.left && (space.left.rightFilled == 'black_connection')):
							return true
							
		'corner_white':
			match orientation:
				'left':
					if (space.left && (space.left.rightFilled == 'white_connection')) || \
						(space.top && (space.top.bottomFilled == 'white_connection')):
							return true
				'top':
					if (space.top && (space.top.bottomFilled == 'white_connection')) || \
						(space.right && (space.right.leftFilled == 'white_connection')):
							return true
				'right':
					if (space.right && (space.right.leftFilled == 'white_connection')) || \
						(space.bottom && (space.bottom.topFilled == 'white_connection')):
							return true
				'bottom':
					if (space.bottom && (space.bottom.topFilled == 'white_connection')) || \
						(space.left && (space.left.rightFilled == 'white_connection')):
							return true
		'corner_black':
			match orientation:
				'left':
					if (space.left && (space.left.rightFilled == 'black_connection')) || \
						(space.top && (space.top.bottomFilled == 'black_connection')):
							return true
				'top':
					if (space.top && (space.top.bottomFilled == 'black_connection')) || \
						(space.right && (space.right.leftFilled == 'black_connection')):
							return true
				'right':
					if (space.right && (space.right.leftFilled == 'black_connection')) || \
						(space.bottom && (space.bottom.topFilled == 'black_connection')):
							return true
				'bottom':
					if (space.bottom && (space.bottom.topFilled == 'black_connection')) || \
						(space.left && (space.left.rightFilled == 'black_connection')):
							return true
							
		'cross_white':
			if (space.left && (space.left.rightFilled == 'white_connection')) || \
				(space.top && (space.top.bottomFilled == 'white_connection')) || \
				(space.right && (space.right.leftFilled == 'white_connection')) || \
				(space.bottom && (space.bottom.topFilled == 'white_connection')):
					return true
		'cross_black':
			if (space.left && (space.left.rightFilled == 'black_connection')) || \
				(space.top && (space.top.bottomFilled == 'black_connection')) || \
				(space.right && (space.right.leftFilled == 'black_connection')) || \
				(space.bottom && (space.bottom.topFilled == 'black_connection')):
					return true
					
		'tower_white':
			if (space.left && (space.left.rightFilled == 'white_border')) || \
				(space.top && (space.top.bottomFilled == 'white_border')) || \
				(space.right && (space.right.leftFilled == 'white_border')) || \
				(space.bottom && (space.bottom.topFilled == 'white_border')):
					return true
		'tower_black':
			if (space.left && (space.left.rightFilled == 'black_border')) || \
				(space.top && (space.top.bottomFilled == 'black_border')) || \
				(space.right && (space.right.leftFilled == 'black_border')) || \
				(space.bottom && (space.bottom.topFilled == 'black_border')):
					return true
	return false


func board_slot_released (boardIndex:int, space:Node) -> void:
	if Globals.holding:
		place_tile(space, Globals.holdingTileType, Globals.holdingOrientation)
	
func place_tile (space:Node, tileType:String, orientation:String) -> void:
	if Globals.holding:
		if (Globals.move == 1 || Globals.move == 2) : ## if the first move of the game
			if is_valid_first_placement(space, tileType, orientation):
				space.place_tile(tileType, orientation)
				%Game.release_holding_tile()
				%Game.post_placement(tileType)
		else: ## if not the first move of the game
			if space.filled == false:
				if is_valid_placement(space, tileType, orientation):
					space.place_tile(tileType, orientation)
					%Game.release_holding_tile()
					%Game.post_placement(tileType)
				else:
					print("not a valid placement!")
			else:
				print("that space is already filled!")
		
	
	

## SIGNALS
