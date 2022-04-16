extends Node

# Node Referencing Global
onready var g_music = $GlobalMusic

# Player
var hit_side
var coins = 0
var life = 3
var checkpoint_position = Vector2.ZERO
var is_checkpoint_hitted = false
var inventory_guns = []

# Game State
var is_playing = false

# Music Functions
func play_music(music_stream) -> void:
	g_music.stream = load(music_stream)
	g_music.play()

func change_volume_music(value) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func get_master_volume() -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
