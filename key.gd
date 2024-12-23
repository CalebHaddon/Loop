extends Area2D
class_name GameKey

signal PickupKey

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.body_entered.connect(func(body:Node2D):
	#	get_tree().reload_current_scene())
	self.body_entered.connect(Collide)
	#connect("Collide", self, "body_entered")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Collide(abody_entered):
	PickupKey.emit(self)
