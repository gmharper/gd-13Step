extends VBoxContainer

func _ready() -> void:
	return

func _process(delta: float) -> void:
	%debug_move_label.text = 'move: ' + str(Globals.move)
	%debug_white_move_label.text = ''
	%debug_black_move_label.text = ''
	%debug_player_label.text = 'activePlayer: ' + str(Globals.activePlayer)
	%debug_index_label.text = 'index: ' + str(Globals.activeIndex)
	%debug_validSpace_label.text = 'validSpace: ' + str(Globals.validSpace)
	if Globals.holding:
		%debug_validBoardSpace_label.text = 'validBoardSpace: ' + str(Globals.validBoardSpace)
	else:
		%debug_validBoardSpace_label.text = 'validBoardSpace: not holding a tile'
	%debug_holding_label.text = 'is holding: ' + str(Globals.holding)
	%debug_tileType_label.text = 'holdingTileType: ' + str(Globals.holdingTile)
	%debug_orientation_label.text = 'holdingTileOrientation: ' + str(Globals.holdingOrientation)
	#%debug_helperEnabled_label.text = 'helperEnabled: ' + str(%Game.helper)
	
