extends Control

@onready var helper:bool = false

func _ready() -> void:
	%Board.placement_error.connect(print_placement_error)
	
func _physics_process(delta: float) -> void:
	if Globals.holding:
		%GhostTile.position = get_global_mouse_position() + Vector2(-25, -25)
		
	%BoardPositionLabel.text = Globals.activeIndex

	
## UTILITY FUNCTIONS
func rotate_holding_tile(tileType:String, tileOrientation:String) -> void:
	%Board.clear_paint_all()
	match tileType:
		'single_white', 'single_black', 'corner_white', 'corner_black', 'triple_white', 'triple_black':
			match tileOrientation:
				'left':
					Globals.holdingOrientation = 'top'
					%GhostTile.rotation_degrees = 0
					return
				'top':
					Globals.holdingOrientation = 'right'
					%GhostTile.rotation_degrees = 90
					return
				'right':
					Globals.holdingOrientation = 'bottom'
					%GhostTile.rotation_degrees = 180
					return
				'bottom':
					Globals.holdingOrientation = 'left'
					%GhostTile.rotation_degrees = 270
					return
		'double_white', 'double_black':
			match tileOrientation:
				'vertical':
					Globals.holdingOrientation = 'horizontal'
					%GhostTile.rotation_degrees = 90
					return
				'horizontal':
					Globals.holdingOrientation = 'vertical'
					%GhostTile.rotation_degrees = 0
					return
				
		'cross_white', 'cross_black':
			return
		'tower_white', 'tower_black':
			return

func release_holding_tile () -> void:
	Globals.holding = false
	Globals.holdingOrientation = 'top'
	Globals.holdingTileType = ''
	%GhostTile.clear()

func post_placement (tileType:String) -> void:
	%Board.clear_paint_all()
	Globals.move += 1
	match Globals.activePlayer:
		'bot':
			%BotTilePanel.reduce_counter(tileType)
			%BotTilePanel.reset()
			Globals.whiteMove += 1
			Globals.activePlayer = 'top'
		'top':
			%TopTilePanel.reduce_counter(tileType)
			%TopTilePanel.reset()
			Globals.blackMove += 1
			Globals.activePlayer = 'bot'
	## stop the player clock
	## switch player turns

func print_placement_error (message:String) -> void:
	%TilePlacementError.text = message

## SIGNALS
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_released('clear'):
		release_holding_tile()
		%TopTilePanel.reset()
		%BotTilePanel.reset()
		print('escape pressed')
	
	if Globals.holding:
		if Input.is_action_just_released('rotate'):
			rotate_holding_tile(Globals.holdingTileType, Globals.holdingOrientation)
		
		if not Globals.validSpace:
			if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_released()):
				release_holding_tile()
				%TopTilePanel.reset()
				%BotTilePanel.reset()
		

func _on_helper_button_pressed() -> void:
	helper = not helper
	if helper:
		$HelperButton.modulate.r = 0
		$HelperButton.modulate.g = 255
		$HelperButton.modulate.b = 0
	else:
		$HelperButton.modulate.r = 255
		$HelperButton.modulate.g = 255
		$HelperButton.modulate.b = 255


func _on_quit_button_pressed() -> void:
	get_tree().quit()
