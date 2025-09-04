extends Control

onready var bgmusic = $Sounds/bgmusic
onready var stats = $stats
var displayed_score = 0  # Store the animated score value
var displayed_Highscore = 0

func _ready():
	bgmusic.play()
	stats.text = "Score: 0"  # Start at 0 to animate from there
	print("Game Over Screen")

func _process(delta):
	# Smoothly update the score counter
	displayed_score = lerp(displayed_score, GLOBALS.score, 5 * delta)
	displayed_Highscore = lerp(displayed_Highscore, GLOBALS.highScore, 1 * delta)
	
	stats.text = "You scored " + str(round(displayed_score)) + " points!\n" + \
				 "High Score: " + str(round(displayed_Highscore)) + " points.\n"

func _input(event):
	if event.is_action_pressed("ui_select"):
		GLOBALS.restart()
	elif event.is_action_pressed("ui_accept"):
		GLOBALS.restart_round()
