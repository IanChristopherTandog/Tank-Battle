extends Node2D

onready var explosion_scene = preload("res://buffs/Explosion.tscn")

func drop(target):
	position = target
	$AnimationPlayer.play("fall")
	$ExplosionTimer.start(1)  
	
func _on_ExplosionTimer_timeout():
	explode()

func explode():
	var explosion = explosion_scene.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()  

#func _input(event):
#	if Input.is_action_just_pressed("artiallary"):
#		$AnimationPlayer.play("fall")
#		$ExplosionTimer.start(1)  

