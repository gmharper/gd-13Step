extends PanelContainer

#%GameInformationLabel
#%MatchTimerLabel
#%BoardPositionLabel
#%PlacementError

func _process(delta: float) -> void:
	if self["theme_override_styles/panel"].border_color.a <= 0:
		var tween = get_tree().create_tween()
		tween.tween_property(self["theme_override_styles/panel"], 'border_color', Color.ORANGE, 10)
	if self["theme_override_styles/panel"].border_color.a >= 1:
		var tween = get_tree().create_tween()
		tween.tween_property(self["theme_override_styles/panel"], 'border_color', Color(1, 1, 1, 0), 10)
