extends ChessPiece


class_name Queen

var visualBlackQueen = preload("res://sceens/black_queen.tscn")
var visualWhiteQueen = preload("res://sceens/white_queen.tscn")


func _init(_pieceIdx, _isBlackPiece = true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackQueen.instantiate()
	else:
		self.visual = visualWhiteQueen.instantiate()
	self.pieceIdx = _pieceIdx
	self.pieceCost = 9


func GetTheNextPosition():
	var coordinates = []
	for i in range(1, 8):
		var top = pieceIdx + (8 * i)
		coordinates.append({
			"direction":directions.Direction.TOP,
			"row": i,
			"col": top
		})
		var left = pieceIdx + i
		coordinates.append({
			"direction":directions.Direction.LEFT,
			"row": 0,
			"col": left
		})
		var topLeft = pieceIdx + (8 * i) + i
		coordinates.append({
			"direction":directions.Direction.TOP_LEFT,
			"row": i,
			"col": topLeft
		})
		var topRight = pieceIdx + (8 * i) - i
		coordinates.append({
			"direction":directions.Direction.TOP_RIGHT,
			"row": i,
			"col": topRight
		})
		i *= -1 
		var down = pieceIdx + (8 * i)
		coordinates.append({
			"direction":directions.Direction.DOWN,
			"row": i,
			"col": down
		})
		var right = pieceIdx + i
		coordinates.append({
			"direction":directions.Direction.RIGHT,
			"row": 0,
			"col": right
		})
		var downLeft = pieceIdx + (8 * i) + i
		coordinates.append({
			"direction":directions.Direction.DOWN_LEFT,
			"row": i,
			"col": downLeft
		})
		var downRight = pieceIdx + (8 * i) - i
		coordinates.append({
			"direction":directions.Direction.DOWN_RIGHT,
			"row": i,
			"col": downRight
		})
		
	return coordinates
