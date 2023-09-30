extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

var powerup_prob = 0.1

func _ready():
	randomize()
	position = new_position
	if score>=100:
		$TextureRect.texture=load("res://Assets/swirl.png")
	elif score>=90:
		$TextureRect.texture=load("res://Assets/sammich.png")
	elif score>=70:
		$TextureRect.texture=load("res://Assets/plaited bread.png")
	elif score>=50:
		$TextureRect.texture=load("res://Assets/rye.png")
	else:
		$TextureRect.texture=load("res://Assets/baguette 2.0.png")

func _physics_process(_delta):
	if dying and not $Flour.emitting:
		queue_free()

func hit(_ball):
	die()

func die():
	$Flour.emitting=true
	dying = true
	collision_layer = 0
	$TextureRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instantiate()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
