extends ChessPiece

class_name Rook

var visualBlackRook = preload("res://scenes/black_rook.tscn")
var visualWhiteRook = preload("res://scenes/white_rook.tscn")

func _init(_pieceIdx, _isBlackPiece = true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackRook.instantiate()
		self.isFor = Constants.blackPlayerLabel

	else:
		self.visual = visualWhiteRook.instantiate()
		self.isFor = Constants.whitePlayerLabel

	self.pieceIdx = _pieceIdx
	self.pieceCost = 5

func GetNextCoordinates():
	var coordinates = []
	for i in range(1, 8):
		var top = pieceIdx + (8 * i)
		coordinates.append({
			"direction": Constants.Direction.TOP,
			"row": i,
			"col": top
		})
		var left = pieceIdx + i
		coordinates.append({
			"direction": Constants.Direction.LEFT,
			"row": 0,
			"col": left
		})
		i *= -1
		var down = pieceIdx + (8 * i)
		coordinates.append({
			"direction": Constants.Direction.DOWN,
			"row": i,
			"col": down
		})
		var right = pieceIdx + i
		coordinates.append({
			"direction": Constants.Direction.RIGHT,
			"row": 0,
			"col": right
		})
	return coordinates