extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var nav: NavigationAgent3D = $NavigationAgent3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	#velocity = velocity.lerp(direction * SPEED, 10* delta)
	var target_position = nav.get_target_position()
	var current_location = position
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_velocity, .25)
	
	move_and_slide()
	#if(direction.x > 0 && direction.z > 0):
		#$car_mesh.rotation.y = lerp_angle($car_mesh.rotation.y, atan(tan(deg_to_rad(90))), delta * 45)
	#if(direction.x > 0 && direction.z < 0):
		#$car_mesh.rotation.y = lerp_angle($car_mesh.rotation.y, atan(tan(deg_to_rad(0))), delta * 45)
	#if(direction.x < 0 && direction.z < 0):
		#$car_mesh.rotation.y = lerp_angle($car_mesh.rotation.y, atan(tan(deg_to_rad(-90))), delta * 45)
	#if(direction.x < 0 && direction.z > 0):
		#$car_mesh.rotation.y = lerp_angle($car_mesh.rotation.y, atan(tan(deg_to_rad(-180))), delta * 45)
	#
		
	#if(position.y < 0):
		#get_tree().change_scene_to_file("res://menu.tscn")
	#Make camera controller match the position of the car
	$Camera_Controller.position = lerp($Camera_Controller.position, position, 0.05)


func update_target_location(target_location):
	nav.set_target_position(target_location)
