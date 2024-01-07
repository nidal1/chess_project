extends ChessPiece


class_name Pawn

func _init(_visual, _pieceIdx, _isBlackPiece = true):
	self.visual = _visual.instantiate()
	self.pieceIdx = _pieceIdx
	self.isBlackPiece = _isBlackPiece


func GetTheNextPosition():
	return [{
		"row" : 0,
		"col": []
	},
	{
		"row" : 1,
		"col": [pieceIdx + 8]
	},
	]
