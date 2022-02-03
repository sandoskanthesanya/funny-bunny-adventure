extends KinematicBody2D

const MAX_SPEED = 50 * 100
const ACCELERATION = 50 * 100
const FRICTION = 10 * 100

enum PLAYER_STATE {IDLE, WALK}
enum LOOK_DIRECTION {DOWN, UP, LEFT, RIGHT}

var playerstate = PLAYER_STATE.IDLE
var lookdirection = LOOK_DIRECTION.DOWN

onready var animationPlayer = $AnimationPlayer

var velocity = Vector2.ZERO

func _physics_process(delta):
	_move(delta)
	_set_direction()
	_change_sprite()


func _set_direction():
	if Input.get_action_strength("player_down"):
		lookdirection = LOOK_DIRECTION.DOWN
	if Input.get_action_strength("player_up"):
		lookdirection = LOOK_DIRECTION.UP
	if Input.get_action_strength("player_left"):
		lookdirection = LOOK_DIRECTION.LEFT
	if Input.get_action_strength("player_right"):
		lookdirection = LOOK_DIRECTION.RIGHT

func _change_sprite():
	var animName
	if playerstate == PLAYER_STATE.IDLE: animName = "player_idle_"
	if playerstate == PLAYER_STATE.WALK: animName = "player_walk_"
	match lookdirection:
		LOOK_DIRECTION.DOWN:
			animationPlayer.play(animName + "down")
		LOOK_DIRECTION.UP:
			animationPlayer.play(animName + "up")
		LOOK_DIRECTION.LEFT:
			animationPlayer.play(animName + "left")
		LOOK_DIRECTION.RIGHT:
			animationPlayer.play(animName + "right")

func _move(delta):
	var input_vector = Vector2()
	input_vector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	input_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
		playerstate = PLAYER_STATE.WALK
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		playerstate = PLAYER_STATE.IDLE
	velocity = move_and_slide(velocity)
