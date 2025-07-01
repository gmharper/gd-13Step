extends PanelContainer

@onready var colour:String = 'white'
@onready var message:String = ''


func set_message (playerName:String, message:String, colour:String) -> void:
	%PlayerName.text = playerName
	%Message.text = message
	%Time.text = str(Time.get_time_dict_from_system().hour) + ":" + str(Time.get_time_dict_from_system().minute)
	
	if colour == 'white':
		return
	elif colour == 'black':
		return
	return
