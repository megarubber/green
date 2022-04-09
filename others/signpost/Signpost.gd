extends Area2D

# Enum
enum State {
	WITHOUT_WRITE,
	CAN_WRITE,
	WRITING,
	WROTE
}

# Variables
export(String) var text_ballon
var sign_state = State.WITHOUT_WRITE
var can_press = true

# Node Referencing
onready var sprite = $Sprite
onready var key = $Key
onready var key_anim = $Key/AnimationPlayer
onready var ballon = $Ballon
onready var ballon_anim = $Ballon/AnimationPlayer
onready var text = $Ballon/Text
onready var text_anim = $Ballon/Text/AnimationPlayerText

func _ready() -> void:
	key.visible = false
	ballon_anim.play("hide")
	text_anim.play("hide")
	text.set_text(text_ballon)

func reset_ballon() -> void:
	ballon_anim.play("backwards")
	sign_state = State.WITHOUT_WRITE
	key_anim.play("hide")
	yield(get_tree().create_timer(0.5), "timeout")
	if get_overlapping_areas().size() == 1:
		key_anim.play("show")
		can_press = true

func write_text() -> void:
	sign_state = State.WRITING
	ballon_anim.play("show")
	key_anim.play("hide")

func _input(event) -> void:
	if event.is_action_pressed("ui_interact") && sign_state != State.WRITING:
		match sign_state: 
			State.CAN_WRITE:
				write_text()
				can_press = false
			State.WROTE:
				reset_ballon()
			State.WITHOUT_WRITE:
				if get_overlapping_areas().size() == 1 && can_press:
					write_text()
					can_press = false

func _on_Signpost_body_entered(body) -> void:
	if body.is_in_group("player"):
		match sign_state:
			State.WROTE:
				key_anim.play("show")
			State.WITHOUT_WRITE:
				sign_state = State.CAN_WRITE
				key_anim.play("show")

func _on_Signpost_body_exited(body) -> void:
	if body.is_in_group("player"):
		match sign_state:
			State.CAN_WRITE:
				sign_state = State.WITHOUT_WRITE
				key_anim.play("hide")
			State.WROTE:
				key_anim.play("hide")

func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == "show":
		text_anim.play("typewriter")
	elif anim_name == "backwards":
		text_anim.play("hide")		

func _on_AnimationPlayerText_animation_finished(anim_name) -> void:
	if anim_name == "typewriter":
		sign_state = State.WROTE
		if get_overlapping_areas().size() == 1:
			key_anim.play("show")
		
func _process(_delta) -> void:
	if get_overlapping_areas().size() == 0:
		key_anim.play("hide")
