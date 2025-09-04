extends "res://tanks/Tank.gd"
	
var base_speed = 400
var boost_speed = 400
var can_boost = true
var erdDuration = 3.0
var erd_active = false

onready var animationPlayer = $TankAnimation
onready var shield = $Shield
onready var erdTimer = $ERDTimer

signal erd_time_updated(time_left)


func control(delta):
	shield.global_rotation	= 0
	$Turret.look_at(get_global_mouse_position())
	var rot_dir = 0
	if Input.is_action_pressed('turn_right'):
		rot_dir += 1
		animationPlayer.play("tankMovement")
	if Input.is_action_pressed('turn_left'):
		rot_dir -= 1
		animationPlayer.play("tankMovement")
	rotation += rotation_speed * rot_dir * delta
	velocity = Vector2()
	if Input.is_action_pressed('forward'):
		velocity += Vector2(max_speed, 0).rotated(rotation)
		animationPlayer.play("tankMovement")
	if Input.is_action_pressed('back'):
		velocity += Vector2(-max_speed, 0).rotated(rotation)
		velocity /= 2.0
		animationPlayer.play("tankMovement")
	if Input.is_action_just_pressed('click'):
		shoot(gun_shots, gun_spread)
#		GLOBALS.PlayerHealth = max_health
	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)
	
	#Added Controls
	if Input.is_action_just_pressed("erd"):
		if GLOBALS.buckshot >= 1:
			erd_active = true
			gun_spread = 0.2
			gun_shots = 5
			GLOBALS.buckshot = max(0, GLOBALS.buckshot - 1)

			erdTimer.wait_time = erdDuration 
			erdTimer.start()

	if Input.is_action_pressed("booster"):
		GLOBALS.fuel = max(0, GLOBALS.fuel - 1)
		if GLOBALS.fuel >= 1:
			max_speed = base_speed + boost_speed
		else:
			max_speed = base_speed

	else:
		max_speed = base_speed
		
func _on_ERDTimer_timeout():
	erd_active = false
	gun_spread = 0.1
	gun_shots = 1
	
func _process(delta):
	if erd_active and erdTimer.time_left > 0:
		emit_signal("erd_time_updated", erdTimer.time_left)

