extends PanelContainer


func _on_moves_toggle_button_pressed() -> void:
	%DebugList.visible = false
	%ChatList.visible = false
	%MoveList.visible = true

func _on_chat_toggle_button_pressed() -> void:
	%DebugList.visible = false
	%ChatList.visible = true
	%MoveList.visible = false

func _on_debug_toggle_button_pressed() -> void:
	%DebugList.visible = true
	%ChatList.visible = false
	%MoveList.visible = false


func _on_chat_input_text_set() -> void:
	pass # Replace with function body.
