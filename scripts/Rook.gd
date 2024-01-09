extends ChessPiece


class_name Rook

func _init(_visual, _pieceIdx, _isBlackPiece = true):
	self.visual = _visual.instantiate()
	self.pieceIdx = _pieceIdx
	self.isBlackPiece = _isBlackPiece
	self.withSpecialMovement = false

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
	return coordinates