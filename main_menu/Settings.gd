extends Control

# Constants
const CHANGE_VOLUME_VALUE = 1

# Node Referencing
onready var main_menu = $BtnMainMenu
onready var volume_slider = $Volume/VolumeSlider
onready var volume_label = $Volume/VolumeLabel
onready var percentage = $Volume/PercentageLabel
onready var fullscreen_label = $FullScreen/FullScreenLabel
onready var fullscreen_checkbox = $FullScreen/FullScreenCheckBox
onready var transition = $TransitionBlock

# Variables
var focus_volume = false

func _ready() -> void:
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
		elif Input.is_action_pressed("ui_right"):
			volume_slider.value += CHANGE_VOLUME_VALUE
		percentage.text = String(volume_slider.value) + "%"

func _on_BtnMainMenu_pressed() -> void:
	enable_buttons(false)
	transition.fade_in()
	yield(transition, "finished")
	var _scene = get_tree().change_scene("res://main_menu/MainMenu.tscn")

func _on_FullScreenCheckBox_focus_entered() -> void:
	fullscreen_label.set("custom_colors/font_color", Color.red)

func _on_FullScreenCheckBox_focus_exited() -> void:
	fullscreen_label.set("custom_colors/font_color", Color.white)

func _on_VolumeSlider_focus_entered() -> void:
	focus_volume = true
	volume_label.set("custom_colors/font_color", Color.red)
	percentage.set("custom_colors/font_color", Color.red)

func _on_VolumeSlider_focus_exited() -> void:
	focus_volume = false
	volume_label.set("custom_colors/font_color", Color.white)
	percentage.set("custom_colors/font_color", Color.white)

func _on_VolumeSlider_mouse_entered() -> void:
	volume_slider.grab_focus()
	print("eeee")

func _on_VolumeSlider_mouse_exited() -> void:
	volume_slider.release_focus()

func _on_FullScreenCheckBox_pressed() -> void:
	if fullscreen_checkbox.pressed:	
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
