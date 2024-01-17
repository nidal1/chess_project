extends ChessPiece


class_name Pawn

func _init(_visual, _pieceIdx, _isBlackPiece = true):
	self.visual = _visual.instantiate()
	self.pieceIdx = _pieceIdx
	self.isBlackPiece = _isBlackPiece
	self.pieceCost = 1


func GetTheNextPosition():

	var row
	if self.isBlackPiece:
		row = 1
	else:
		row = -1

	return [{
		"row" : 0,
		"col": []
	},
	{
		"row" : row,
		"col": [pieceIdx + 8 * row]
	},
	]
