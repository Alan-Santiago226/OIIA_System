extends CanvasLayer

func play_fade_start(animation: String = "START") -> void:
	$AnimationPlayer.play(animation)
	#await get_tree().create_timer(1).timeout
	
