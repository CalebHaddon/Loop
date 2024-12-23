extends TileMap

signal PlayerRestart

var UsedCells : Array[Vector2i] = []
var Player : CharacterBody2D
var PlayerRecordScene = load("res://player_record.tscn")
var ExpiredCellScene = load("res://cell_expired.tscn")
var PlayerRecords : Array[Node2D]
var ExpiredSprites : Array[Sprite2D]
var CurrentPlayerRecord : Node2D

var LevelDurationSeconds = 0
var LevelElapsedSeconds = 0

var IsActive = false

var ActiveColor = Color(1, 1, 1, 1)
var InActiveColor = Color(0.5, 0.5, 0.5, 0.5)
var ExpiredCellColor = Color(0.5, 0.5, 0.5, 0.5)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("type", "LoopMap")
	LevelDurationSeconds = get_used_rect().size.x	
	SetActive(false, null)
	var sortedUsedCells = get_used_cells(0).duplicate()
	sortedUsedCells.sort()
	for coord in sortedUsedCells:
		var cellSprite = ExpiredCellScene.instantiate()
		cellSprite.position = map_to_local(coord)
		cellSprite.visible = false
		cellSprite.modulate = ExpiredCellColor
		add_child(cellSprite)
		ExpiredSprites.push_back(cellSprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	LevelElapsedSeconds += delta
	if LevelElapsedSeconds > LevelDurationSeconds:
		Reset()
	
	if Player:
		if Player.isSpawning:
			if LevelElapsedSeconds >= CurrentPlayerRecord.TileMapStartTime:
				Player.CompleteSpawn()
				
	UpdateTileColor()	

func UpdateTileColor():
	var expiredIndex = ceil(LevelElapsedSeconds)
	for index in ExpiredSprites.size():
		ExpiredSprites[index].visible = index < expiredIndex
		

func SetActive(inIsActive : bool, inPlayer : CharacterBody2D):
	IsActive = inIsActive
	if IsActive:
		Player = inPlayer
		set_layer_modulate(0, ActiveColor)

		# start a new player record
		CurrentPlayerRecord = PlayerRecordScene.instantiate()
		add_child(CurrentPlayerRecord)
		CurrentPlayerRecord.StartRecord(Player, self, false)

	else:
		Player = null
		set_layer_modulate(0, InActiveColor)
		if CurrentPlayerRecord:
			# complete the record
			CurrentPlayerRecord.StopRecord()
			PlayerRecords.append(CurrentPlayerRecord)

func Reset():
	LevelElapsedSeconds = 0
	if Player:
		Player.StartSpawn(CurrentPlayerRecord.GetSpawnLocation())
		
		# re-record the respawned player 
		CurrentPlayerRecord.StartRecord(Player, self, true)
		
		PlayerRestart.emit(Player)
