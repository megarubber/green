extends Area2D

# Enum
enum State {
	CLOSED,
	CAN_OPEN,
	OPENED
}

# Variables
var chest_state = State.CLOSED
export(bool) var flip_chest
export(String) var item_path
export(Vector2) var global_size_item
export(bool) var instance_multiple_itens
export(int) var n_multiple_instances = 0

# Node Referencing
onready var sprite = $AnimatedSprite
onready var key = $Key
onready var key_anim = $Key/AnimationPlayer
onready var instance_p = $InstancePosition
onready var instance_anim = $InstancePosition/AnimationPlayer
onready var sfx = $OpenChest

func _ready() -> void:
	sprite.flip_h = flip_chest
	instance_p.position.x = -60 if (flip_chest) else 60
	sprite.play("default")
	key.visible = false

func open_chest() -> void:
	sprite.play("open")
	chest_state = State.OPENED
	key_anim.play_backwards("show")

func instance_item() -> void:
	var _i = load(item_path).instance()
	_i.scale = global_size_item
	if instance_multiple_itens:
		for _k in range(n_multiple_instances):
			instance_p.add_child(_i, true)
			_i.apply_impulse(Vector2.ZERO, Vector2(rand_range(60, -60), -150))
			_i.name = String(_k)
			_i = null
			_i = load(item_path).instance()
	else:
		instance_p.add_child(_i)
		_i.visible = false
		instance_anim.play("created")
		_i.visible = true

func _input(event) -> void:
	if event.is_action_pressed("ui_interact") && chest_state == State.CAN_OPEN:
		open_chest()
		sfx.play()

func _on_Chest_body_entered(body) -> void:
	if body.is_in_group("player") && chest_state == State.CLOSED:
		chest_state = State.CAN_OPEN
		key.visible = true
		key_anim.play("show")

func _on_Chest_body_exited(body) -> void:
	if body.is_in_group("player") && chest_state == State.CAN_OPEN:
		chest_state = State.CLOSED
		key_anim.play_backwards("show")

func _on_AnimatedSprite_animation_finished():
	if sprite.get_animation() == "open":
		instance_item() 
