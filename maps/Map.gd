extends Node2D

onready var bgmusic = $Sounds/bgmusic
onready var enemyLabel = $EnemyDetection/EnemiesCount
onready var animate = $Mission/AnimationPlayer

onready var plane_shadow_scene = preload("res://buffs/PlaneShadow.tscn")
onready var missile_scene = preload("res://buffs/AirstrikeTarget.tscn")
onready var targetLocation = preload("res://effects/ArtilleryTarget.tscn")

var enemyCount = 0
var player_dead = false  
var target_instance = null

func _ready():
	set_camera_limits()
	Input.set_custom_mouse_cursor(load("res://assets/UI/crossair_black.png"), Input.CURSOR_ARROW, Vector2(16, 16))
	$Player.map = $Ground
	
	bgmusic.play()
	animate.play("Display")

func set_camera_limits():
	var map = $Ground
	var limits = map.get_used_rect()
	var cell_size = map.cell_size
	var camera = $Player/Camera2D
	
	camera.limit_left = limits.position.x * cell_size.x
	camera.limit_right = limits.end.x * cell_size.x
	camera.limit_top = limits.position.y * cell_size.y
	camera.limit_bottom = limits.end.y * cell_size.y

func _on_Tank_shoot(bullet, position, direction, target=null):
	var b = bullet.instance()
	add_child(b)
	b.start(position, direction, target)

func _on_Player_dead():
	player_dead = true  # Set the player as dead
	print("Player died")
	GLOBALS.dead() 

func _on_EnemyDetection_body_entered(_body):
	enemyCount += 1
	update_enemy_count()

func _on_EnemyDetection_body_exited(_body):
	enemyCount -= 1
	update_enemy_count()

func update_enemy_count():
	if player_dead:
		return  

	if enemyCount == 1:
		enemyLabel.text = "1 Enemy Remaining!"
	elif enemyCount <= 0:
		yield(get_tree().create_timer(2.0), "timeout")
		GLOBALS.score_screen()  
	else:
		enemyLabel.text = "Enemies Left: " + str(enemyCount)

func _input(event):
	if Input.is_action_just_pressed("click"):
		if GLOBALS.artillary > 0 and target_instance != null:
			call_airstrike()	
			GLOBALS.artillary -= 1
			confirm_targeting()
		else:
			pass
	if Input.is_action_just_pressed("artillery") and GLOBALS.artillary > 0:
		if target_instance == null:
			start_targeting()
		else:
			confirm_targeting()

	if target_instance != null and event is InputEventMouseMotion:
		target_instance.global_position = get_global_mouse_position()
		
func call_airstrike():
	var target = get_global_mouse_position()  
	var plane_shadow = plane_shadow_scene.instance()
	add_child(plane_shadow)
	plane_shadow.start_flyby(target)
	
	yield(get_tree().create_timer(1), "timeout")
	
	var missile = missile_scene.instance()
	add_child(missile)
	missile.drop(target)
	
func start_targeting():
	target_instance = targetLocation.instance()
	add_child(target_instance)

func confirm_targeting():
	target_instance.queue_free()
	target_instance = null
	
