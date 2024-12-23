extends Node2D

var Helpers = preload("res://helpers.gd")

var worldTime = 0
var player : CharacterBody2D
var maps : Array[Node2D]
var hud : Node2D
var playerLabel : Label
var tileConstantToTileMap = {}
var ActiveTileMap
var keys : Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("type","World")
	Helpers.printAllChildTypes(self, "")
	player = Helpers.findChildOfType(self, "Player")
	initTileMapArray(self)
	playerLabel = Label.new()
	add_child(playerLabel)
	
	Helpers.findChildrenOfType(self, "GameKey", keys)
	for key in keys:
		key.PickupKey.connect(OnPickupKey)
	
	initTileMapArray(self)
	print("initTileMapArray : %d TileMaps" % maps.size())
	for tileMapEntry in tileConstantToTileMap:
		print("tileMapConstant : %d" % tileMapEntry)
		print("tileMap.name : %s" % tileConstantToTileMap[tileMapEntry].name)
	
	hud = Helpers.getHUD(self)

	for tileMap in maps:
		tileMap.PlayerRestart.connect(OnPlayerRestart)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	worldTime += delta
	#updatePlayerLabel()
	var playerCoord = maps[0].local_to_map(player.position)
	var playerTileMapConstant = calcTileMapConstantFromCoord(playerCoord)
	if tileConstantToTileMap.has(playerTileMapConstant):
		setActiveTileMap(tileConstantToTileMap[playerTileMapConstant])
	
func setActiveTileMap(inTileMap : TileMap):
	if inTileMap != ActiveTileMap:
		if ActiveTileMap:
			ActiveTileMap.SetActive(false, null)
		ActiveTileMap = inTileMap
		hud.SetTileMap(ActiveTileMap)
		if ActiveTileMap:
			ActiveTileMap.SetActive(true, player)	

func updatePlayerLabel():
	var playerCoord = maps[0].local_to_map(player.position)
	playerLabel.text = "(%d,%d)" % [playerCoord.x, playerCoord.y]
	playerLabel.position = player.position

func initTileMapArray(node : Node):
	Helpers.getMaps(self, maps)
	for someTile in maps:
		var tileMapConstant = calcTileMapConstantFromCoord(someTile.get_used_cells(0)[0])
		tileConstantToTileMap[tileMapConstant] = someTile

func calcTileMapConstantFromCoord(coord) -> int:
	return ceil(coord.y + 0.5 * coord.x)

func OnPickupKey(InKey : Node2D):
	$HUD.AddInventory(InKey)

func OnPlayerRestart(InPlayer : Node2D):
		pass
