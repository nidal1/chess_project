extends ChessPiece

class_name King

var visualBlackKing = preload("res://sceens/black_king.tscn")
var visualWhiteKing = preload("res://sceens/white_king.tscn")


func _init(_pieceIdx, _isBlackPiece = true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackKing.instantiate()
	else:
		self.visual = visualWhiteKing.instantiate()
	self.pieceIdx = _pieceIdx
	self.pieceCost = 1
	self.withSpecialMovement = false

func GetTheNextPosition():
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
