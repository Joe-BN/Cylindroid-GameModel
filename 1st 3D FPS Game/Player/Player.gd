extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = -.98
export var jump_power = 30
export var mouse_sensitivity = 0.2

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	
	if Input.is_action_pressed("Move_Forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("Move_Backward"):
		direction += head_basis.z
		
	if Input.is_action_pressed("Move_Right"):
		direction += head_basis.x
	elif Input.is_action_pressed("Move_Left"):
		direction -= head_basis.x
	
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y += gravity
	velocity = move_and_slide(velocity)
	
