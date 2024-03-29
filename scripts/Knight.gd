extends ChessPiece


class_name Knight
var visualBlackKnight = preload("res://sceens/black_knight.tscn")
var visualWhiteKnight = preload("res://sceens/white_knight.tscn")

func _init(_pieceIdx, _isBlackPiece = true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackKnight.instantiate()
	else:
		self.visual = visualWhiteKnight.instantiate()
	self.pieceIdx = _pieceIdx
	self.pieceCost = 3
	self.withSpecialMovement = false


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

