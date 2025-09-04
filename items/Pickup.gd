extends Area2D

enum Items {health, ammo, shield,bomber, buckshot}

var icon_textures = [preload("res://assets/effects/wrench_white.png"), 
					preload("res://assets/effects/ammo_machinegun.png"),preload("res://assets/shield_silver (large).png"),preload("res://assets/explosions/AttackAircraft.png"),preload("res://assets/effects/Buckshot_Icon.png")]
export (Items) var type = Items.health
export (Vector2) var amount = Vector2(10, 25)


func _ready():
	$Icon.texture = icon_textures[type]
	 

func _on_Pickup_body_entered(body):
	match type:
		Items.health:
			if body.has_method('heal'):
				body.heal(int(rand_range(amount.x, amount.y)))
				GLOBALS.full_fuel()
		Items.ammo:
			body.ammo += int(rand_range(amount.x, amount.y))
			
		Items.shield:
			GLOBALS.shield += 1
		Items.bomber:
			GLOBALS.artillary += 1
		Items.buckshot:
			GLOBALS.buckshot += 1
			
	queue_free()
