extends ChessPiece

class_name King

func _init(_visual, _pieceIdx, _isBlackPiece = true):
	self.visual = _visual.instantiate()
	self.pieceIdx = _pieceIdx
	self.isBlackPiece = _isBlackPiece

func MoveToLastPosition():
	return [{
		"row" : 0,
		"col": [pieceIdx + 1, pieceIdx - 1]
	},
	{
		"row" : 1,
		"col": [pieceIdx + 8, pieceIdx + 8 + 1, pieceIdx + 8 - 1]
	},
	{
		"row" : -1,
		"col": [pieceIdx - 8, pieceIdx - 8 + 1, pieceIdx - 8 - 1]
	}
	]
