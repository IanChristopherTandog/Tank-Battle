extends "res://bullets/Bullet.gd"

onready var gunshot = $Sounds/Gunshot

func _ready():
	gunshot.play()
