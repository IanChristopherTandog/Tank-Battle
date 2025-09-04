extends Node2D

var target_pos = Vector2()

func _ready():
	visible = false
	
func start_flyby(target):
#	position = Vector2(100, target.y - 100) 
	position = Vector2(target.x, target.y - 100	)
	target_pos = target
	visible = true
	$AnimationPlayer.play("flyby")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()  
