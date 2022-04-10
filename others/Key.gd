extends Sprite

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "show":
		visible = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hide":
		visible = false
