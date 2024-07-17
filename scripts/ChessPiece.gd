class_name ChessPiece

var gameRules = preload ("res://scripts/GameRule.gd").new()

var pieceIdx: int
var visual: Node3D
var isBlackPiece: bool
var withSpecialMovement: bool = true
var pieceCost: int
var isFor: String
var isMoved: bool = false

#func SwitchColor():
#	var material:Material = StandardMaterial3D.new()
#	if isBlackPiece:
#		material.albedo_color = Color(255,255,255)
#	else:
#		material.albedo_color = Color(0,0,0)
#	visual.get_node("RootNode").get_child(0).set_surface_override_material(0, material)

func GetNextCoordinates() -> Array:
	return []

func CanMove(other: ChessPiece) -> bool:
	if other:
		return int(self.isBlackPiece) + int(other.isBlackPiece) == 1
	else:
		return true

func LocalizationOfSelectedPiece() -> int:
	return ((self.pieceIdx / Constants.ROWS)) + 1

func IsThePieceReachesTheSides(piece: ChessPiece) -> bool:
	var row
	if piece.isBlackPiece:
		row = Constants.ROWS
	else:
		row = 1
	return row == self.LocalizationOfSelectedPiece()

func GetNextPositions() -> Dictionary:
	var currentRowPosition = self.LocalizationOfSelectedPiece()
	# calculate the incoming positions
	var coordinations = self.GetNextCoordinates()
	var nextCoordinates = {
		"withSpecialMovement": self.withSpecialMovement,
		"nextPositions":[]
	}
	for coor in coordinations:
		var nextSelectedRow = currentRowPosition + coor.row
		var isNextSelectedRowBetweenEdges = nextSelectedRow > 0 and nextSelectedRow <= Constants.ROWS
		if isNextSelectedRowBetweenEdges:
			var boundaries: Array[int] = Constants.GetTheBoundariesOfASelectedRow(nextSelectedRow)
			var selectedCol = coor.col
			var firstIdx = boundaries[0]
			var lastIdx = boundaries[1]
			var isSelectedColBetweenEdges = selectedCol >= firstIdx and selectedCol <= lastIdx
			if isSelectedColBetweenEdges:
				nextCoordinates.nextPositions.append({
					"nextCol": selectedCol,
					"direction": coor.direction if coor.has("direction") else null
				})

	return nextCoordinates
