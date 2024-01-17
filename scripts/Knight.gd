extends ChessPiece


class_name Knight

func _init(_visual, _pieceIdx, _isBlackPiece = true):
	self.visual = _visual.instantiate()
	self.pieceIdx = _pieceIdx
	self.isBlackPiece = _isBlackPiece
	self.pieceCost = 3


func GetTheNextPosition():
	return [{
		"row" : 1,
		"col": [pieceIdx + 8 -2, pieceIdx + 8 + 2]
	},
	{
		"row" : 2,
		"col": [ pieceIdx + 16 -1, pieceIdx + 16 +1]
	}
	,
	{
		"row" : -1,
		"col": [ pieceIdx - 8 -2, pieceIdx - 8 + 2]
	},
	{
		"row" : -2,
		"col": [pieceIdx - 16 -1, pieceIdx - 16 +1]
	}
	]

