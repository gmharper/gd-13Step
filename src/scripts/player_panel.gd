extends PanelContainer

@export var tile_panel:Node
@export var profile_panel:Node
@export var border:Node

@export var pos:String
@export var colour:String = 'white'
@export var player:Dictionary = {
	username = '',
	avatar_img = '',
	avatar_img_url = '',
	profile_banner_img = '',
	profile_banner_img_url = '',
	primary_colour = '',
	secondary_colour = '',
	rating = 0
}

func _ready() -> void:
	profile_panel.draw_profile(player)
	tile_panel.draw_tile_panel(pos, colour, [16, 12, 10, 8, 4, 0])
	return
	
func _process(delta: float) -> void:
	if Globals.activePlayer == pos:
		if border["theme_override_styles/panel"].border_color.a <= 0:
			var tween = get_tree().create_tween()
			tween.tween_property(border["theme_override_styles/panel"], 'border_color', Color.INDIGO, 2)
		if border["theme_override_styles/panel"].border_color.a >= 1:
			var tween = get_tree().create_tween()
			tween.tween_property(border["theme_override_styles/panel"], 'border_color', Color(1, 1, 1, 0), 2)
