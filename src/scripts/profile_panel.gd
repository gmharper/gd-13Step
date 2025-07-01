extends PanelContainer

func _ready() -> void:
	return
	
func draw_profile (player:Dictionary) -> void:
	if player:
		%PlayerName.text = player.username
		%PlayerRating.text = str(player.rating)
		
		if player.avatar_img:
			%ProfilePicture.texture = load(player.avatar_img)
		elif player.avatar_img_url:
			%ProfilePicture.texture = load(player.avatar_img_url)
			
		%PlayerTimer.text = str(0)
		return
		
func clear () -> void:
	%PlayerName.text = 'username'
	%PlayerRating.text = 'rating'
	%ProfilePicture.texture = null
	%PlayerTimer.text = '0:00'
	
