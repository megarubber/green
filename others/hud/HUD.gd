extends CanvasLayer

# Node Referencing
onready var game_over_anim = $GameOver/AnimationPlayer
onready var game_over_screen = $GameOver
onready var game_over_r_anim = $GameOverReset/AnimationPlayerGR
onready var game_over_r_screen = $GameOverReset
onready var start_anim = $StartLevel/AnimationPlayerStart
onready var start = $StartLevel
onready var level_name_label = $StartLevel/LevelName
onready var level_number_label = $StartLevel/LevelNumber
onready var pause_screen = $Pause
onready var pause_screen_anim = $Pause/AnimationPlayerPause
onready var select = $SelectSoundEffect
onready var change = $ChangeSoundEffect
onready var spacebar = $SpacebarSoundEffect
onready var inventory = $InventoryGuns
onready var finish_level = $FinishLevel
onready var finish_level_a = $FinishLevel/AnimationPlayerFinish 
onready var finish_sfx = $FinishedSoundEffect

# Variables
var can_pause_delay = false
var next_level = false

# Get Transition Node
export(NodePath)var transition_path
onready var transition = get_node(transition_path)

# Get Settings Menu
onready var settings = preload("res://main_menu/SettingsGame.tscn")

# Textures Gun
export(Array, StreamTexture)var gun_texture

func _ready() -> void:
	var level_name_reference = get_tree().get_current_scene().get_name()
	match level_name_reference:
		"Level1":
			level_number_label.set_text("STAGE 01")
			level_name_label.set_text("Samueland City")
	var player = get_tree().get_current_scene().get_node("Player")
	player.connect("player_death", self, "_player_death")
	
	var f = get_tree().get_current_scene().get_node("FinishLevel/FinishLevel")
	f.connect("finished_level", self, "_finish_level")
	
	invisible_special_screens()
	enable_pause_buttons(false)
	
	# Name and Stage Number Initializing
	start.visible = true
	start_anim.play("start")
	
	# Can Pause Delay is prevent the player to pause the game between transition
	yield(transition, "finished")
	can_pause_delay = true

func _finish_level() -> void:
	Global.stop_music()
	finish_sfx.play()
	yield(get_tree().create_timer(3.5), "timeout")
	Global.is_playing = false
	finish_level.get_node("LabelSpacebar").visible = false
	finish_level.visible = true
	finish_level_a.play("fade_in")
	yield(get_tree().create_timer(3), "timeout")
	next_level = true
	finish_level.get_node("LabelSpacebar").visible = true
	finish_level.get_node("LabelSpacebar/AnimationPlayer").play("default")

func _process(_delta) -> void:
	if len(Global.inventory_guns) < 2:
		inventory.visible = false
	else:
		inventory.visible = true
		inventory.get_node("Gun").texture = gun_texture[Global.inventory_guns[0]]

func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_pause") && !next_level && Global.is_playing && can_pause_delay:
		pause_game(true)
	
	if event.is_action_pressed("ui_accept") && next_level:
		spacebar.play()
		next_level = false
		transition.fade_in()
		yield(transition, "finished")
		Global.reset_all()
		var _result = get_tree().change_scene("res://main_menu/Credits.tscn")

# Pausing game
func pause_game(value : bool) -> void:
	if value:
		get_tree().paused = true
		Global.is_playing = false
		pause_screen.visible = true
		pause_screen_anim.play("paused")
		yield(get_tree().create_timer(0.7), "timeout")
		pause_screen.get_node("Board/BtnResume").grab_focus()
		enable_pause_buttons(true)
	else:
		pause_screen_anim.play_backwards("paused")
		enable_pause_buttons(false)
		yield(get_tree().create_timer(1), "timeout")
		get_tree().paused = false
		Global.is_playing = true
		pause_screen.visible = false

func invisible_special_screens() -> void:
	game_over_screen.visible = false
	pause_screen.visible = false

func _player_death() -> void:
	if Global.life > 0:
		game_over_screen.visible = true
		game_over_anim.play("fade_in")
		enable_game_over_buttons(false)
	else:
		game_over_r_screen.visible = true
		game_over_r_anim.play("fade_in")
		yield(get_tree().create_timer(3), "timeout")
		transition.fade_in()
		yield(transition, "finished")
		var _result = get_tree().change_scene("res://others/game_over/GameOver.tscn")

func return_to_menu() -> void:
	transition.fade_in()
	Global.reset_all()
	yield(transition, "finished")
	get_tree().paused = false
	var _result = get_tree().change_scene("res://main_menu/MainMenu.tscn")

func restart_level() -> void:
	transition.fade_in()
	Global.coins = 0
	yield(transition, "finished")
	get_tree().paused = false
	var _result = get_tree().reload_current_scene()

func enable_game_over_buttons(value : bool) -> void:
	game_over_screen.get_node("BtnTryAgain").disabled = !value
	game_over_screen.get_node("BtnMainMenu").disabled = !value

func _on_AnimationPlayer_animation_finished(_anim_name) -> void:
	game_over_anim.stop()
	enable_game_over_buttons(true)
	game_over_screen.get_node("BtnTryAgain").grab_focus()

func _on_AnimationPlayerStart_animation_finished(_anim_name) -> void:
	start.queue_free()

func _on_BtnTryAgain_pressed() -> void:
	select.play()
	restart_level()

func _on_BtnResume_pressed() -> void:
	select.play()
	pause_game(false)

func enable_pause_buttons(value : bool) -> void:
	pause_screen.get_node("Board/BtnRestartLevel").disabled = !value
	pause_screen.get_node("Board/BtnSettings").disabled = !value
	pause_screen.get_node("Board/BtnResume").disabled = !value
	pause_screen.get_node("Board/BtnMainMenu").disabled = !value

func _on_BtnMainMenu_pressed() -> void:
	select.play()
	return_to_menu()

func _on_BtnRestartLevel_pressed() -> void:
	select.play()
	var actual_life = Global.life
	Global.reset_all()
	Global.life = actual_life
	restart_level()

func _on_BtnTryAgain_focus_entered() -> void:
	change.play()

func _on_BtnMainMenu_focus_entered() -> void:
	change.play()

func _on_BtnResume_focus_entered() -> void:
	change.play()

func _on_BtnSettings_focus_entered() -> void:
	change.play()

func _on_BtnRestartLevel_focus_entered() -> void:
	change.play()

func _on_BtnSettings_pressed() -> void:
	select.play()
	enable_pause_buttons(false)
	transition.fade_in()
	yield(transition, "finished")
	var s = settings.instance()
	add_child(s)
	yield(s, "exited")
	transition.fade_out()
	yield(transition, "finished")
	enable_pause_buttons(true)
	pause_screen.get_node("Board/BtnResume").grab_focus()
