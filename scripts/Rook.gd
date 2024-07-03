extends ChessPiece


class_name Rook

var visualBlackRook = preload("res://sceens/black_rook.tscn")
var visualWhiteRook = preload("res://sceens/white_rook.tscn")

func _init(_pieceIdx, _isBlackPiece = true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackRook.instantiate()
	else:
		self.visual = visualWhiteRook.instantiate()
	self.pieceIdx = _pieceIdx
	self.pieceCost = 5

func GetTheNextPosition():
	var coordinates = []
	for i in range(1, 8):
		var top = pieceIdx + (8 * i)
		coordinates.append({
			"direction":constants.Direction.TOP,
			"row": i,
			"col": top
		})
		var left = pieceIdx + i
		coordinates.append({
			"direction":constants.Direction.LEFT,
			"row": 0,
			"col": left
		})
		i *= -1 
		var down = pieceIdx + (8 * i)
		coordinates.append({
			"direction":constants.Direction.DOWN,
			"row": i,
			"col": down
		})
		var right = pieceIdx + i
		coordinates.append({
			"direction":constants.Direction.RIGHT,
			"row": 0,
			"col": right
		})
	return coordinates