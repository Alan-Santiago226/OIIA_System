extends Control

var U = preload("res://Assets/Music/1-A.mp3")
var I = preload("res://Assets/Music/2-B.mp3")
var A = preload("res://Assets/Music/3-C Loop.mp3")
var rng = RandomNumberGenerator.new()

var U_re = preload("res://Assets/Music/1-A Reverse.mp3")
var I_re = preload("res://Assets/Music/2-B Reverse.mp3")
var A_re = preload("res://Assets/Music/3-C Loop Reverse.mp3")

var music_decition = rng.randi_range(1, 3)
var change = false
var is_reverse = false
var music_pos: float = 0.0

var tween: Tween = null

func _ready() -> void:
	$scene_fade.show()
	#music_decition = 3
	$Audio_Background.pitch_scale = 1.8
	print("1")
	play_music(music_decition, false)
	#$Change.connect("timeout",_on_change_timeout())
	$scene_fade.play_fade_start()
	

#func loop_music() -> void:
#	var playback = $Audio_Background.get_playback()
#	if playback:
#		playback.loop_offset = 3.0

func play_music(select: int, is_reversed: bool) -> void:
	print("2")
	match select:
		1:
			if is_reversed:
				$Audio_Background.stream = U_re
			else:
				$Audio_Background.stream = U
			$Audio_Background.volume_db = -3
			print("Playing 1-A")
		2:
			if is_reversed:
				$Audio_Background.stream = I_re
			else:
				$Audio_Background.stream = I
			$Audio_Background.volume_db = 0
			print("Playing 2-B")
		3:
			if is_reversed:
				$Audio_Background.stream = A_re
			else:
				$Audio_Background.stream = A
			$Audio_Background.volume_db = -10
			print("Playing 3-C")
	$Audio_Background.play()
	#var wait_time = $Audio_Background.stream.get_length()
	#if not change:
	#	change = true
	#	$Change.start(wait_time)
	print("Duración del audio: ",$Audio_Background.stream.get_length(), " segundos" )
	#print("Timer duración: ", $Change.wait_time," estado: ", $Change.is_stopped())
	print("")

#func _on_change_timeout():
#	change = false
#	print("3")
#	$Audio_Background.stop()
#	print("el temporizador se acaba y se detiene la musica")
#	match music_decition:
#		1:
#			change_music(1)
#		2:
#			change_music(2)
#		3:
#			change_music(3)

func change_music(index: int, alt: bool) -> void:
	print("4")
	print("Llega a la siguiente canción")
	var play_1 = [2, 3]
	var play_2 = [1, 3]
	var play_3 = [1, 2]
	match index:
		1:
			music_decition = play_1.pick_random()
			play_music(music_decition, alt)
		2:
			music_decition = play_2.pick_random()
			play_music(music_decition, alt)
		3:
			music_decition = play_3.pick_random()
			play_music(music_decition, alt)

func _on_audio_background_finished():
	print("La canción finalizó - eligiendo la siguiente")
	print("")
	change_music(music_decition, is_reverse)


func _on_i_2_pressed():
	if tween == null:
		tween = get_tree().create_tween()
		tween.set_parallel(true)
	verify_reversed()
	$VBoxContainer/HBoxContainer/I2.disabled = true
	$Cooldown.start()
	#tween.tween_callback($VBoxContainer/HBoxContainer/I2.queue_free())

func verify_reversed() -> void:
	if is_reverse == false:
		reverse_music(1)
		colors_UI(1)
	else:
		reverse_music(0)
		colors_UI(2)
		
func reverse_music(index: int) -> void:
	music_pos = $Audio_Background.get_playback_position()
	if index == 1:
		is_reverse = true
		play_reverse(is_reverse)
		#print("La posición actual de la canción es: ", music_pos)
	else:
		is_reverse = false
		play_reverse(is_reverse)

func play_reverse(con: bool) -> void:
	$Audio_Background.stop()
	match music_decition:
		1:
			if con:
				$Audio_Background.stream = U_re
				$Audio_Background.play(U.get_length() - music_pos)
			else:
				$Audio_Background.stream = U
				$Audio_Background.play(U_re.get_length() - music_pos)
		2:
			if con:
				$Audio_Background.stream = I_re
				$Audio_Background.play(I.get_length() - music_pos)
			else:
				$Audio_Background.stream = I
				$Audio_Background.play(I_re.get_length() - music_pos)
		3:
			if con:
				$Audio_Background.stream = A_re
				$Audio_Background.play(A.get_length() - music_pos)
			else:
				$Audio_Background.stream = A
				$Audio_Background.play(A_re.get_length() - music_pos)

func colors_UI(index : int) -> void:
	var props = ["theme_override_colors/font_color","theme_override_colors/font_pressed_color","theme_override_colors/font_hover_color"]
	var buttons = [$VBoxContainer/HBoxContainer/U, $VBoxContainer/HBoxContainer/I, $VBoxContainer/HBoxContainer/I2, $VBoxContainer/HBoxContainer/A, $VBoxContainer/HBoxContainer/A2]
	match index:
		1:
			tween.tween_property($ParallaxBackground/ColorRect,"color", Color.BLACK, 0.75)
			for i in buttons:
				for prop in props:
					if i == buttons[2]:
						if prop == props[0]:
							tween.tween_property(i,prop, Color.WHITE, 1)
							tween.tween_property(i,"theme_override_colors/font_disabled_color", Color.WHITE, 1)
						else:
							tween.tween_property(i,prop, Color.AQUA, 1)
					else:
						tween.tween_property(i,prop, Color.WHITE, 1)
		2:
			tween.tween_property($ParallaxBackground/ColorRect,"color", Color.WHITE, 0.75)
			for i in buttons:
				for prop in props:
					if i == buttons[2]:
						if prop == props[0]:
							tween.tween_property(i,prop, Color.BLACK, 1)
							tween.tween_property(i,"theme_override_colors/font_disabled_color", Color.BLACK, 1)
						else:
							tween.tween_property(i,prop, Color.RED, 1)
					else:
						tween.tween_property(i,prop, Color.BLACK, 1)
	#tween.finished.connect(tween.queue_free)
	tween = null

func _on_cooldown_timeout():
	$VBoxContainer/HBoxContainer/I2.disabled = false
