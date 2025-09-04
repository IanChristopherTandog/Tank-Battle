extends Node2D

export (PackedScene) var indicator_scene

var indicators = {}  # Stores enemy indicators
var player = null
var camera = null
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

	# Find Player
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		player = player_nodes[0]

	# Find Camera
	var camera_nodes = get_tree().get_nodes_in_group("camera")
	if camera_nodes.size() > 0:
		camera = camera_nodes[0]
		print("✅ Camera found:", camera)
	else:
		print("❌ Camera not found! Ensure it's in the 'camera' group.")

func _process(delta):
	# Stop execution if player or camera is deleted
	if player == null or not is_instance_valid(player) or camera == null or not is_instance_valid(camera):
		return  

	var enemies = get_tree().get_nodes_in_group("enemies")

	# Remove invalid (deleted) enemies from indicators
	var to_remove = []
	for enemy in indicators.keys():
		if not is_instance_valid(enemy):
			indicators[enemy].queue_free()
			to_remove.append(enemy)
	
	for enemy in to_remove:
		indicators.erase(enemy)

	# Add missing indicators for new enemies
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue  # Skip if enemy is already deleted

		if not indicators.has(enemy):
			if indicator_scene:
				var indicator = indicator_scene.instance()
				add_child(indicator)
				indicators[enemy] = indicator
			else:
				print("❌ Error: Indicator scene is not assigned!")

		update_indicator(enemy, indicators[enemy], delta)

func update_indicator(enemy, indicator, delta):
	# Stop execution if player, enemy, or camera is deleted
	if player == null or not is_instance_valid(player) or enemy == null or not is_instance_valid(enemy) or camera == null or not is_instance_valid(camera):
		return

	var enemy_screen_pos = enemy.global_position - camera.global_position + screen_size / 2

	# Check if enemy is on-screen
	var is_enemy_on_screen = (
		enemy_screen_pos.x >= 0 and enemy_screen_pos.x <= screen_size.x and
		enemy_screen_pos.y >= 0 and enemy_screen_pos.y <= screen_size.y
	)

	if is_enemy_on_screen:
		indicator.hide()  # Hide indicator when enemy is visible
	else:
		indicator.show()

		# Get direction from player to enemy
		var direction = (enemy.global_position - player.global_position).normalized()

		# Set indicator position at screen edge
		var indicator_dist = min(screen_size.x, screen_size.y) / 1 - 30  
		var indicator_pos = screen_size / 2 + direction * indicator_dist

		# Keep indicator within screen bounds
		indicator_pos.x = clamp(indicator_pos.x, 30, screen_size.x - 30)
		indicator_pos.y = clamp(indicator_pos.y, 30, screen_size.y - 30)

		# Smooth movement
		indicator.position = indicator.position.linear_interpolate(indicator_pos, delta * 10)
		indicator.rotation = direction.angle()
