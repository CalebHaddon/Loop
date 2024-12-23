extends Label

var Helpers = preload("res://helpers.gd")

var TimerTileMap : TileMap
var World : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !World:
		World = Helpers.getParentWorld(self)
	
	if World:
		text = "%2.1f" % World.worldTime
	else:
		text = "poo"

func SetTileMap(inTileMap:TileMap):
	TimerTileMap = inTileMap
