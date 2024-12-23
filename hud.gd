extends Node2D

var TimerLabel : Label
var Inventory : Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("type", "HUD")
	TimerLabel = get_child(0). get_child(0). get_child(0). get_child(0)

# Called everSy frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SetTileMap(inTileMap : TileMap):
	TimerLabel.SetTileMap(inTileMap)
	
func AddInventory(InKey : Node2D):
	Inventory.push_back(InKey)
	InKey.reparent(get_child(0).get_child(0), false)
	InKey.position = Vector2(48,16)
