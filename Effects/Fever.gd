extends Node2D

var t=0
var maxb=7
var tween= null

func start_fever():
	tween=create_tween().set_parallel(true)
	fever()
	$Timer.start()
	var fever_indicator = get_node_or_null("/root/Game/UI/HUD/Fever")
	if fever_indicator != null:
		fever_indicator.use_parent_material = false
	var fire = get_node_or_null("/root/Game/Fire")
	if fire != null:
		fire.use_parent_material = false
		tween.tween_property(fire, "modulate:a", .7, 2)
		
func end_fever():
	pass

func _on_Timer_timeout():
	if Global.feverish:
		fever()
		$Timer.start()
		t+=1
		if t>maxb:
			var fire = get_node_or_null("/root/Game/Fire")
			Global.feverish=false
			tween= create_tween()
			tween.tween_property(fire, "modulate:a", 0, 2)
			await tween.finished
	else:
		var fever_indicator = get_node_or_null("/root/Game/UI/HUD/Fever")
		if fever_indicator != null:
			fever_indicator.use_parent_material = true
		Global.fever=0

func fever():
	var ball_container = get_node_or_null("/root/Game/Ball_Container")
	if ball_container != null:
		ball_container.make_ball_fever()
	var camera = get_node_or_null("/root/Game/Camera")
	if camera != null:
		camera.add_trauma(3.0)
