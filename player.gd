extends CharacterBody2D

const SPEED = 20.0
var isSpawning = false
var AliveColor = Color(1, 1, 1, 1)
var SpawnColor = Color(0.5, 0.5, 0.5, 0.5)
var SpawnTimeScale = 2
var isGhost = false
var GhostColor = Color(1, 0.5, 0.5, 1)

func _ready():
	set_meta("type", "Player")

func _physics_process(delta):
	if isSpawning:
		pass
	
	if !isSpawning && !isGhost:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction:
			var rotatedDirection = direction.rotated(-0.785398163)
			rotatedDirection.x *= 2
			self.velocity = rotatedDirection * SPEED
		else:
			self.velocity = Vector2.ZERO
			
		move_and_slide()

func StartSpawn(inLocation : Vector2):
	isSpawning = true
	set_global_position(inLocation)
	set_modulate(SpawnColor)
	#Engine.time_scale = SpawnTimeScale
	print("StartSpawn")
	
func CompleteSpawn():
	isSpawning = false
	set_modulate(AliveColor)
	Engine.time_scale = 1	
	print("CompleteSpawn")

func SetGhost():
	isGhost = true
	set_modulate(GhostColor)

	
