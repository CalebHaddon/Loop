extends Node

static func getParentWorld(inNode : Node) -> Node2D:
	return getParentOfType(inNode, "World")
	
static func getParentMap(inNode : Node) -> Node2D:
	return getParentOfType(inNode, "LoopMap")

static func getMaps(inWorld : Node2D, result : Array[Node2D]):
	findChildrenOfType(inWorld, "LoopMap", result)	

static func getHUD(inWorld : Node2D) -> Node2D:
	return findChildOfType(inWorld, "HUD")

static func getKeys(inMap : Node2D, result : Array):
	findChildrenOfType(inMap, "GameKey", result)

static func getParentOfType(inNode : Node, inTypeName : String) -> Node2D:
	while inNode && !inNode.get_meta("type") == inTypeName:
		inNode = inNode.get_parent()
	return inNode

static func findChildrenOfType(inNode: Node, inTypeName : String, result : Array):
	if inNode.get_meta("type") == inTypeName:
		result.push_back(inNode)
	for child in inNode.get_children():
		findChildrenOfType(child, inTypeName, result)

static func findChildOfType(inNode : Node, inTypeName : String) -> Node2D:
	for child in inNode.get_children():
		if child.get_meta("type") == inTypeName:
			return child
		var result = findChildOfType(child, inTypeName)
		if result:
			return result
	return null

static func printAllChildTypes(inNode: Node, inIndent : String):
	if inNode.has_meta("type"):
		print("%s%s : %s" % [inIndent, inNode.get_class(), inNode.get_meta("type")])
	else:
		print("%s%s" % [inIndent, inNode.get_class()])	
	inIndent = "%s." % inIndent
	for child in inNode.get_children():
		printAllChildTypes(child, inIndent)
	
	
