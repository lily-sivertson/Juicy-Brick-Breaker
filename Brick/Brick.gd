extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var tween

var sway_amplitude = 3.0

var powerup_prob = 0.1

var color_index = 0
var color_distance = 0
var color_completed = true
var color_initial_position = Vector2.ZERO
var color_randomizer = Vector2.ZERO

func _ready():
	randomize()
	position.x = new_position.x
	position.y= -100
	#$TextureRect.modulate.a=.5 #also add some sort of fire/oven anim under loaves before level
	#$TextureRect.modulate.v=.5
	$TextureRect.scale=Vector2(.4,.4)
	tween = create_tween().set_parallel(true) #make it so the bread rises when the level starts
	position=new_position
	#tween.tween_property(self, "position", new_position, 0.5 + randf()*2).set_trans(Tween.TRANS_BOUNCE)
	#tween.tween_property($TextureRect, "modulate:v", 1, 1+ randf()*.5)
	tween.tween_property($TextureRect, "modulate", Color(1,1,1), 1+ randf()*.5)
	tween.tween_property($TextureRect, "scale" ,Vector2(.8,.8), 1+ randf())
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
	color_initial_position = $TextureRect.position
	color_randomizer = Vector2(randf()*6-3.0, randf()*6-3.0)
		
	#tween.tween_property($TextureRect, "modulate:a", 1.0, 0.5+randf()*1.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _physics_process(_delta):
	if dying and not tween:
		queue_free()
	elif not get_tree().paused:
		color_distance = Global.color_position.distance_to(global_position)  / 100
		if Global.color_rotate >= 0:
			#$ColorRect.color = colors[(int(floor(color_distance + Global.color_rotate))) % len(colors)]
			color_completed = false
		elif not color_completed:
			#$ColorRect.color = colors[color_index]
			color_completed = true
		var pos_x = (sin(Global.sway_index)*(sway_amplitude + color_randomizer.x))
		var pos_y = (cos(Global.sway_index)*(sway_amplitude + color_randomizer.y))
		$TextureRect.position = Vector2(color_initial_position.x + pos_x, color_initial_position.y + pos_y)

	
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
	var brick_audio = get_node_or_null("/root/Game/Brick_Sound")
	if brick_audio != null:
		brick_audio.play()
