extends Control

# Signals
signal exited

# Constants
const CHANGE_VOLUME_VALUE = 0.1

# Node Referencing
onready var main_menu = $Options/BtnMainMenu
onready var volume_slider = $Options/Volume/VolumeSlider
onready var volume_label = $Options/Volume/VolumeLabel
onready var percentage = $Options/Volume/PercentageLabel
onready var fullscreen_label = $Options/FullScreen/FullScreenLabel
onready var fullscreen_checkbox = $Options/FullScreen/FullScreenCheckBox
onready var transition = $TransitionBlock
onready var select = $SelectSoundEffect
onready var change = $ChangeSoundEffect
onready var without_fullscreen = $WithoutFullScreen

# Variables
var focus_volume = false

func _ready() -> void:
	volume_slider.value = db2linear(Global.get_master_volume())
	percentage.text = String(round(volume_slider.value * 100)) + "%"
	enable_buttons(false)
	transition.fade_out()
	yield(transition, "finished")
	enable_buttons(true)
	if OS.window_fullscreen:	
		fullscreen_checkbox.pressed = true
	else:
		fullscreen_checkbox.pressed = false
	volume_slider.grab_focus()

func enable_buttons(value : bool) -> void:
	volume_slider.editable = value
	fullscreen_checkbox.disabled = !value
	main_menu.disabled = !value

func _process(_delta : float) -> void:
	if focus_volume:
		if Input.is_action_pressed("ui_left"):
			volume_slider.value -= CHANGE_VOLUME_VALUE
			Global.change_volume_music(linear2db(volume_slider.value))
		elif Input.is_action_pressed("ui_right"):
			volume_slider.value += CHANGE_VOLUME_VALUE
			Global.change_volume_music(linear2db(volume_slider.value))
		percentage.text = String(round(volume_slider.value * 100)) + "%"

func _on_BtnMainMenu_pressed() -> void:
	select.play()
	enable_buttons(false)
	transition.fade_in()
	yield(transition, "finished")
	if get_name() == "SettingsGame":
		queue_free()
	else:		
		var _scene = get_tree().change_scene("res://main_menu/MainMenu.tscn")

func _on_FullScreenCheckBox_focus_entered() -> void:
	change.play()
	fullscreen_label.set("custom_colors/font_color", Color.red)

func _on_FullScreenCheckBox_focus_exited() -> void:
	fullscreen_label.set("custom_colors/font_color", Color.white)

func _on_VolumeSlider_focus_entered() -> void:
	change.play()
	focus_volume = true
	volume_label.set("custom_colors/font_color", Color.red)
	percentage.set("custom_colors/font_color", Color.red)

func _on_VolumeSlider_focus_exited() -> void:
	focus_volume = false
	volume_label.set("custom_colors/font_color", Color.white)
	percentage.set("custom_colors/font_color", Color.white)

func _on_VolumeSlider_mouse_entered() -> void:
	volume_slider.grab_focus()

func _on_VolumeSlider_mouse_exited() -> void:
	if focus_volume:
		volume_slider.grab_focus()
	else:		
		volume_slider.release_focus()

func _on_FullScreenCheckBox_pressed() -> void:
	if fullscreen_checkbox.pressed:
		select.play()
		OS.window_fullscreen = true
	else:
		without_fullscreen.play()
		OS.window_fullscreen = false

func _on_BtnMainMenu_focus_entered() -> void:
	change.play()

func _on_SettingsGame_tree_exited():
	emit_signal("exited")
