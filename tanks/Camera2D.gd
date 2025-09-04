extends Camera2D

var shake_amount = 0  
var shake_decay = 15

func _process(delta):
	if shake_amount > 0:
		shake_amount = max(shake_amount - shake_decay * delta, 0)
		offset = Vector2(randf() - 0.5, randf() - 0.5) * shake_amount
	else:
		offset = Vector2.ZERO 

func start_shake(amount):
	shake_amount = amount
