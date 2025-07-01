extends VBoxContainer

const CHAT_MESSAGE = preload("res://src/scenes/ChatMessage.tscn")

@onready var chatHistory = []

##
func _ready() -> void:
	return

func postMessage (message:String, player:String) -> void:
	var newMessage = {
		'player': player,
		'message': message,
		'time': Time.get_time_dict_from_system()
	}
	chatHistory.append(newMessage)
	
	rerender()
	return

func rerender () -> void:
	for child in self.get_children():
		child.queue_free()
		
	for chatMessage in chatHistory:
		var ChatMessage = CHAT_MESSAGE.instantiate()
		ChatMessage.set_message(chatMessage.player, chatMessage.message, Globals.activeColour)
		self.add_child(ChatMessage)

func _on_chat_input_text_submitted(new_text: String) -> void:
	postMessage(new_text, Globals.activePlayer)
	pass # Replace with function body.
