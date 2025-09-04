extends Control

onready var bgmusic = $Sounds/bgmusic

func _ready():
	bgmusic.play()
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		Transition.fade_out()
		GLOBALS.start_game()
