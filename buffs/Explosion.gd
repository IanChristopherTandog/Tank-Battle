extends StaticBody2D

var damage = 100

func _ready():
	$AnimatedSprite.play("Explode")
	$Crater.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Crater.visible = true
	$AnimationPlayer.play("crate")

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$CollisionShape2D.set_deferred("disabled", false)
	$Damage/CollisionShape2D.set_deferred("disabled", true)
#	queue_free()

func _on_Damage_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(damage)
	if body.is_in_group("explosives"):
		body.deal_damage(damage)
