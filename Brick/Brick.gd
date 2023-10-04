extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var tween

var powerup_prob = 0.1

func _ready():
	randomize()
	position.x = new_position.x
	position.y= -100
	$TextureRect.modulate.a=.5 #also add some sort of fire/oven anim under loaves before level
	tween = create_tween().set_parallel(true) #make it so the bread rises when the level starts
	tween.tween_property(self, "position", new_position, 0.5 + randf()*2).set_trans(Tween.TRANS_BOUNCE)
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
		
	tween.tween_property($TextureRect, "modulate:a", 1.0, 0.5+randf()*1.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _physics_process(_delta):
	if dying and not $Flour.emitting and not tween:
		queue_free()

func hit(_ball):
	die()

func die():
	#add crunching noise upon death
	#make the bread break apart on death
	
	$Flour.emitting=true
	dying = true
	collision_layer = 0
	tween= create_tween().set_parallel(false)
	tween.tween_property($TextureRect, "modulate:v", .25, 1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($TextureRect, "modulate:a", 0, 1.2).set_ease(Tween.EASE_IN_OUT)
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
