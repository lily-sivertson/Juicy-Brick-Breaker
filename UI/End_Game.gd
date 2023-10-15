extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Label2.text= "Your final score was "+ str(Global.score) +"!"
