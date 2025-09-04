extends Control

onready var stats = $Stats
onready var timer = $Timer
onready var message = $Message
onready var bgmusic = $Sounds/bgmusic
onready var cheering = $Sounds/cheer
onready var score = $Sounds/increaseScore
onready var title = $Title

var displayed_score = 0
var displayed_Highscore = 0

func _ready():
	timer.start()
	bgmusic.play()
	cheering.play()
	score.play()
	Transition.fade_in()

func _process(delta):
	# Smoothly update the displayed score & high score
	displayed_score = lerp(displayed_score, GLOBALS.score, 5 * delta)
	displayed_Highscore = lerp(displayed_Highscore, GLOBALS.highScore, 5 * delta) # Matched speed for consistency
	
	# Display the current round's results
	stats.text = "You scored " + str(round(displayed_score)) + " points!\n" + \
				 "High Score: " + str(round(displayed_Highscore)) + " points.\n" + \
				 "Get ready for the next round!"
	
	message.text = str(int(timer.time_left)) + " seconds before proceeding to the next round..."

	# Final Screen Logic
	if GLOBALS.current_level >= 2:
		timer.stop()
		message.visible = false
		title.text = "🎉 Congratulations! 🎉"

		# Check if a new high score was achieved
		if GLOBALS.score >= GLOBALS.highScore:
			stats.text = "You finished with " + str(round(displayed_score)) + " points!\n" + \
						 "🔥 New High Score: " + str(round(displayed_Highscore)) + " points! 🔥\n" + \
						 "Ready for another run?\n" + \
						"Press Enter to Play Again!"
						
			if Input.is_action_just_pressed("EndPlayAgain"):
				GLOBALS.restart()
		else:
			stats.text = "You finished with " + str(round(displayed_score)) + " points!\n" + \
						 "High Score to beat: " + str(round(displayed_Highscore)) + " points.\n" + \
						 "Think you can do even better?\n" + \
						"Press Enter to Play Again!"
						
			if Input.is_action_just_pressed("EndPlayAgain"):
				GLOBALS.restart()

func _on_Timer_timeout():	
	GLOBALS.next_level()
	Transition.fade_in()
