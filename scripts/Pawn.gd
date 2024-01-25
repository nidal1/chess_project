extends ChessPiece


class_name Pawn

var visualBlackPawn = preload("res://sceens/black_pawn.tscn")
var visualWhitePawn = preload("res://sceens/white_pawn.tscn")


var isTheFirstMove : bool = true

func _init(_pieceIdx, _isBlackPiece = true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackPawn.instantiate()
	else:
		self.visual = visualWhitePawn.instantiate()
	self.pieceIdx = _pieceIdx
	self.pieceCost = 1

func GetAllOppositePiecePositions():
	var direction
	if self.isBlackPiece:
		direction = 1
	else:
		direction = -1
	
	return {
		"row": 1 * direction,
		"col": [pieceIdx + 8 * direction + 1 , pieceIdx + 8 * direction - 1]
	}
	

func GetTheNextPosition():

	var direction
	if self.isBlackPiece:
		direction = 1
	else:
		direction = -1

	if isTheFirstMove:
		return [{
			"row" : 0,
			"col": []
		},
		{
			"row" : 1 * direction,
			"col": [pieceIdx + 8 * direction]
		},
		{
			"row" : 2 * direction,
			"col": [pieceIdx + 8 * 2 * direction]
		},
		]
	else:
		return [{
			"row" : 0,
			"col": []
		},
		{
			"row" : 1 * direction,
			"col": [pieceIdx + 8 * direction]
		}
		]
