extends Node

const MAX_FUEL = 100
const GAME_OVER_SCENE = "res://ui/GameOver.tscn"
const scoreBoard = "res://ui/ScoreBoard.tscn"

var slow_terrain = [0, 10, 20, 30, 7, 8, 17, 18, 30, 40]
var levels = ["res://ui/TitleScreen.tscn", "res://maps/Map01.tscn","res://maps/Map02.tscn"]
var current_level = 0
var PlayerHealth

var score = 0
var fuel = MAX_FUEL
var shield = 0
var artillary = 0
var buckshot = 0
var highScore = 1000

func start_game():
	current_level += 1
	fuel = MAX_FUEL
	score = 0
	shield = 0
	buckshot = 0
	artillary = 0
	get_tree().change_scene(levels[current_level])

func restart():
	current_level = 0
	get_tree().change_scene(levels[current_level])
	
func restart_round():
	print("Restarting current level:", current_level)
	fuel = MAX_FUEL
	score = 0
	shield = 0
	buckshot = 0
	artillary = 0
	get_tree().change_scene(levels[current_level])

func next_level():
	if current_level > 0:
		current_level += 1
		get_tree().change_scene(levels[current_level])
	else:
		restart()
func dead():
	Transition.fade_out()
	get_tree().change_scene(GAME_OVER_SCENE)

func score_screen():
	get_tree().change_scene(scoreBoard)

func full_fuel():
	fuel = MAX_FUEL
	
func _process(delta):
	if score > highScore:
		highScore = score
