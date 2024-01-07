extends ChessPiece


class_name BlackKnight

func _init(visual, pieceIdx, _isBlackPiece = true):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = _isBlackPiece


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

