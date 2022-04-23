extends Node

# Node Referencing Global
onready var g_music = $GlobalMusic

# Player
var hit_side = 1
var coins = 0
var life = 3
var checkpoint_position = Vector2.ZERO
var is_checkpoint_hitted = false
var inventory_guns = []
var score = 0
var total_score = 0
var finished_level = false

# Game State
var is_playing = false

# Music Functions
func play_music(music_stream) -> void:
	g_music.stream = load(music_stream)
	g_music.play()

func stop_music() -> void:
	g_music.stop()

func change_volume_music(value) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func get_master_volume() -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

func reset_all() -> void:
	hit_side = 1
	coins = 0
	life = 3
	checkpoint_position = Vector2.ZERO
	is_checkpoint_hitted = false
	is_playing = false
	total_score = 0
	score = 0
	finished_level = false
