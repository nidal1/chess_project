extends ChessPiece


class_name WhiteRook

func _init(visual, pieceIdx, _isBlackPiece = true):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = _isBlackPiece
	self.withSpicialMovement = false


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
