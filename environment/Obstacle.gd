tool
extends StaticBody2D

export var max_hp := 20

var hp
var damage = 20
var cause_damage = false

onready var explode = $Explode
onready var explodeDamage = $Explode/CollisionShape2D2

func _ready():
	explode.visible = false
	explodeDamage.set_deferred("disabled", true)
	hp = max_hp
	
	if type in [Items.barrelBlack_side, Items.barrelBlack_top,
				Items.barrelGreen_side, Items.barrelGreen_top,
				Items.barrelRed_side, Items.barrelRed_top,
				Items.barrelRust_side, Items.barrelRust_top,
				Items.barricadeMetal]: 
		add_to_group("explosives")


enum Items {barrelBlack_side, barrelBlack_top, barrelGreen_side,
			barrelGreen_top, barrelRed_side, barrelRed_top, barrelRust_side,
			barrelRust_top, barricadeMetal, barricadeWood, fenceRed, fenceYellow,
			sandbagBeige, sandbagBeige_open, sandbagBrown, sandbagBrown_open,
			treeBrown_large, treeBrown_small, treeGreen_large, treeGreen_small}

var regions = {
	Items.barrelBlack_side: Rect2(532, 90, 56, 40),
	Items.barrelBlack_top: Rect2(220, 89, 48, 48),
	Items.barrelGreen_side: Rect2(476, 90, 56, 40),
	Items.barrelGreen_top: Rect2(220, 137, 48, 48),
	Items.barrelRed_side: Rect2(420, 94, 56, 40),
	Items.barrelRed_top: Rect2(172, 89, 48, 48),
	Items.barrelRust_side: Rect2(588, 90, 56, 40),
	Items.barrelRust_top: Rect2(172, 137, 48, 48),
	Items.barricadeMetal: Rect2(532, 130, 56, 56),
	Items.barricadeWood: Rect2(72, 130, 56, 56),
	Items.fenceRed: Rect2(336, 443, 32, 96),
	Items.fenceYellow: Rect2(216, 550, 32, 104),
	Items.sandbagBeige: Rect2(164, 282, 44, 64),
	Items.sandbagBeige_open: Rect2(518, 350, 55, 84),
	Items.sandbagBrown: Rect2(622, 278, 44, 64),
	Items.sandbagBrown_open: Rect2(596, 450, 55, 84),
	Items.treeBrown_large: Rect2(0, 654, 128, 128),
	Items.treeBrown_small: Rect2(694, 118, 72, 72),
	Items.treeGreen_large: Rect2(128, 654, 128, 128),
	Items.treeGreen_small: Rect2(694, 190, 72, 72)
}

export (Items) var type setget _update

func _update(_type):
	type = _type
	#if !Engine.editor_hint:
	yield(self, 'tree_entered')
	$Sprite.region_rect = regions[type]
	var rect = RectangleShape2D.new()
	rect.extents = $Sprite.region_rect.size / 2
	$CollisionShape2D.shape = rect

func deal_damage(amount):
	hp -= amount
	if hp <= 0:
		trigger_explosion()

func trigger_explosion(): 
	explode.visible = true
	GLOBALS.score += 10
	$Explode/Explosion.play("fire") 
	explodeDamage.set_deferred("disabled", false)


func _on_Explosion_animation_finished():
	explodeDamage.set_deferred("disabled", false)
	queue_free()


func _on_Explode_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(damage)
	if body.is_in_group("explosives"):
		body.deal_damage(damage)
