extends TextureProgress

# Variables
var lifeMax = 100
var life = 0

func _ready() -> void:
	# Life sets to max value
	life = lifeMax

# Damage function
func damage(strength : int) -> void:
	life -= strength
	value = life

# Heal function
func heal(strength : int) -> void:
	life += strength
	value = life

# Returns if player or enemy is dead
func getDeath() -> bool:
	if life <= 0:
		return true
	else:
		return false
