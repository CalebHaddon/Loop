extends Button

var RotationSpeed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(self._button_pressed)

func _button_pressed(): 
	get_tree().reload_current_scene()
	
func _process(delta):
	#rotation += delta * RotationSpeed
	pass
