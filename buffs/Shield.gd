extends StaticBody2D

func _ready():
	set_shield_active(false) 
	visible = false

func activate_shield():
	
	set_shield_active(true)  
	visible = true
	yield(get_tree().create_timer(5.0), "timeout")  
#	$Timer.start()
	set_shield_active(false)  
	visible = false

func set_shield_active(active: bool):
	for shape in get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", !active) 

func _input(event):
	if Input.is_action_just_pressed("shield"):
		if GLOBALS.shield > 0:
			activate_shield()
			GLOBALS.shield -= 1
			print("Shield Activated! Remaining Shields: ", GLOBALS.shield)
		else:
			pass
