extends CanvasLayer

var bar_red = preload("res://assets/UI/barHorizontal_red_mid 200.png")
var bar_green = preload("res://assets/UI/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://assets/UI/barHorizontal_yellow_mid 200.png")
var bar_texture

onready var HealthBarTween = $Margin/Container/HealthBar/Tween
onready var gas = $fuelProgress
onready var scoreLabel = $scoreLabel
onready var shieldLabel = $BuffSlot/Shield/ShieldLabel
onready var artiallaryLabel = $BuffSlot/Bomber/ArtillaryLabel
onready var buckshotLabel = $BuffSlot/Buckshot/Label
onready var erd_bar = $BuffSlot/Buckshot/ERDProgressBar

var displayed_score = 0
var displayed_Highscore = 0

func _update_erd_bar(time_left):
	erd_bar.value = time_left  
	erd_bar.visible = time_left > 0

func update_ammo(value):
	$Margin/Container/AmmoGauge.value = value
	
func update_healthbar(value):
	bar_texture = bar_green
	if value < 60:
		bar_texture = bar_yellow
	if value < 25:
		bar_texture = bar_red
	$Margin/Container/HealthBar.texture_progress = bar_texture
	HealthBarTween.interpolate_property($Margin/Container/HealthBar,
			'value', $Margin/Container/HealthBar.value, value,
			0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	HealthBarTween.start()
	$AnimationPlayer.play("healthbar_flash")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'healthbar_flash':
		$Margin/Container/HealthBar.texture_progress = bar_texture
	$BuffSlot/Shield.modulate = Color.white
	$BuffSlot/Bomber.modulate = Color.white
	$BuffSlot/Buckshot.modulate = Color.white

func _process(delta):
	gas.value = GLOBALS.fuel
	displayed_score = lerp(displayed_score, GLOBALS.score, 5 * delta)
	displayed_Highscore = lerp(displayed_Highscore, GLOBALS.highScore, 5 * delta)
	
	scoreLabel.text = str("%010d" % round(displayed_score))
	$highScoreLabel.text = "HighSore: "+str("%010d" % round(GLOBALS.highScore))
	
	shieldLabel.text = str(GLOBALS.shield)
	artiallaryLabel.text = str(GLOBALS.artillary) 
	buckshotLabel.text = str(GLOBALS.buckshot)
	
	
	
	if Input.is_action_just_pressed("shield"):
		if GLOBALS.shield <= 0:
			$AnimationPlayer.play("ShieldFlash")
			$Empty.play()
	if Input.is_action_just_pressed("artillery"):
		if GLOBALS.artillary <= 0:
			$AnimationPlayer.play("BomberFlash")
			$Empty.play()

	if Input.is_action_just_pressed("erd"):
		if GLOBALS.buckshot <= 0:
			$AnimationPlayer.play("BuckshotFlash")
			$Empty.play()
	
