extends Node2D

var MaxTime = 20
var SampleRate = 2
var SamplesPerSecond = 30
var Player : CharacterBody2D
var PlayerScene = load("res://player.tscn")
var PlayerGhost : CharacterBody2D
var PlayerTileMap : TileMap
var TileMapStartTime = 0
var TileMapEndTime = 0
var RecordIndex = 0
var LastRecordIndex = 0

var Locations : Array[Vector2] = []
var maxLocationCount = MaxTime * SamplesPerSecond

func _ready():
	Locations.resize(maxLocationCount)
	Locations.fill(0)

func _process(delta):
	if PlayerTileMap:
		if Player:
			if !Player.isSpawning:
				Record(delta)
		else:
			PlayBack(delta)

func StartRecord(inPlayer : CharacterBody2D, inTileMap : TileMap, isRestart : bool):
	RecordIndex = 0
	Player = inPlayer
	PlayerTileMap = inTileMap
	if !isRestart:
		TileMapStartTime = inTileMap.LevelElapsedSeconds

func StopRecord():
	if Player != null:
		Player = null
		TileMapEndTime = PlayerTileMap.LevelElapsedSeconds
		LastRecordIndex = RecordIndex
		RecordIndex = 0
	
func Record(delta):
	Locations[RecordIndex] = Player.position
	RecordIndex += 1
	if RecordIndex == maxLocationCount:
		StopRecord()
	
func PlayBack(delta):
	# is the record stopped
	if TileMapEndTime <= PlayerTileMap.LevelElapsedSeconds:
		# destroy the ghost
		if PlayerGhost:
			PlayerGhost.queue_free()
			PlayerGhost = null
			RecordIndex = 0
		
	else:
		# is the record started
		if TileMapStartTime <= PlayerTileMap.LevelElapsedSeconds:
			if PlayerGhost == null:
				PlayerGhost = PlayerScene.instantiate()
				add_child(PlayerGhost)
				PlayerGhost.SetGhost()
				RecordIndex = 0
		
			PlayerGhost.position = Locations[RecordIndex]
			RecordIndex += 1
			RecordIndex = min(RecordIndex, LastRecordIndex)
			
func GetSpawnLocation() -> Vector2:
	return Locations[0]
	
