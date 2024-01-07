extends ChessPiece


class_name BlackBishop

func _init(visual, pieceIdx, _isBlackPiece = true):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = _isBlackPiece
	self.withSpicialMovement = false


func GetTheNextPosition():
	var coordinates = []
	for i in range(1, 8):
		var topLeft = pieceIdx + (8 * i) + i
		coordinates.append({
			"direction":"top-left",
			"row": i,
			"col": topLeft
		})
		var topRight = pieceIdx + (8 * i) - i
		coordinates.append({
			"direction":"top-right",
			"row": i,
			"col": topRight
		})
		i *= -1 
		var downLeft = pieceIdx + (8 * i) + i
		coordinates.append({
			"direction":"down-left",
			"row": i,
			"col": downLeft
		})
		var downRight = pieceIdx + (8 * i) - i
		coordinates.append({
			"direction":"down-right",
			"row": i,
			"col": downRight
		})
	return coordinates