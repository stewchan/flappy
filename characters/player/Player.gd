extends RigidBody2D
class_name Player

const MAX_ROTATION_DEGREES = -30

signal died

export var FLAP_FORCE = -200

onready var animator = $AnimationPlayer
onready var hit = $Hit
onready var wing = $Wing

var started = false
var alive = true


func _physics_process(_delta):
	# if Input.is_action_just_pressed("flap") && alive:
	# 	if not started:
	# 		start()

	if rotation_degrees <= MAX_ROTATION_DEGREES:
		angular_velocity = 0
		rotation_degrees = MAX_ROTATION_DEGREES

	if linear_velocity.y > 0:
		if rotation_degrees <= 90:
			angular_velocity = 3
		else:
			angular_velocity = 0


func _input(event):
	if event is InputEventScreenTouch and event.is_pressed() and alive:
		if not started:
			gravity_scale = 5
			start()


func start():
	if started:
		return
	started = true
	flap()


# Flap the bird
func flap():
	animator.play("flap")
	wing.play()
	linear_velocity.y = FLAP_FORCE
	angular_velocity = -8
	started = false


func die():
	if not alive:
		return
	animator.stop()
	hit.play()
	alive = false
	emit_signal("died")
