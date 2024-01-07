extends ChessPiece


class_name BlackRook

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
			"direction":"top",
			"row": i,
			"col": top
		})
		var left = pieceIdx + i
		coordinates.append({
			"direction":"left",
			"row": 0,
			"col": left
		})
		i *= -1 
		var down = pieceIdx + (8 * i)
		coordinates.append({
			"direction":"down",
			"row": i,
			"col": down
		})
		var right = pieceIdx + i
		coordinates.append({
			"direction":"right",
			"row": 0,
			"col": right
		})
	return coordinates