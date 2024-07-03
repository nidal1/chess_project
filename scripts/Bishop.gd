extends ChessPiece


class_name Bishop

var visualBlackBishop = preload("res://sceens/black_bishop.tscn")
var visualWhiteBishop = preload("res://sceens/white_bishop.tscn")

func _init(_pieceIdx, _isBlackPiece = true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackBishop.instantiate()
	else:
		self.visual = visualWhiteBishop.instantiate()
	self.pieceIdx = _pieceIdx
	self.pieceCost = 3


func GetTheNextPosition():
	var coordinates = []
	for i in range(1, 8):
		var topLeft = pieceIdx + (8 * i) + i
		coordinates.append({
			"direction":constants.Direction.TOP_LEFT,
			"row": i,
			"col": topLeft
		})
		var topRight = pieceIdx + (8 * i) - i
		coordinates.append({
			"direction":constants.Direction.TOP_RIGHT,
			"row": i,
			"col": topRight
		})
		i *= -1 
		var downLeft = pieceIdx + (8 * i) + i
		coordinates.append({
			"direction":constants.Direction.DOWN_LEFT,
			"row": i,
			"col": downLeft
		})
		var downRight = pieceIdx + (8 * i) - i
		coordinates.append({
			"direction":constants.Direction.DOWN_RIGHT,
			"row": i,
			"col": downRight
		})
	return coordinates