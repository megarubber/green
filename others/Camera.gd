extends Camera2D

# Get Player
onready var limit = get_parent().limit_camera_end_level

# Limit end level camera
func _ready():
	limit_right = limit
