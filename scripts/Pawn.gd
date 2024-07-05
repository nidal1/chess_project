extends ChessPiece

class_name Pawn

var visualBlackPawn = preload ("res://sceens/black_pawn.tscn")
var visualWhitePawn = preload ("res://sceens/white_pawn.tscn")

var isTheFirstMove: bool = true
var direction: int

func _init(_pieceIdx, _isBlackPiece=true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackPawn.instantiate()
		direction = 1
		self.isFor = Constants.blackPlayerLabel

	else:
		self.visual = visualWhitePawn.instantiate()
		self.isFor = Constants.whitePlayerLabel
		direction = -1
	self.pieceIdx = _pieceIdx
	self.pieceCost = 1
	self.withSpecialMovement = false

func GetAllOppositePiecePositions():
	
	return [{
		"row": 1 * direction,
		"col": pieceIdx + 8 * direction + 1
	},
	{
		"row": 1 * direction,
		"col": pieceIdx + 8 * direction - 1
	}
	]

func GetTheNextPosition():

	if isTheFirstMove:
		return [
		{
			"row": 1 * direction,
			"col": pieceIdx + 8 * direction
		},
		{
			"row": 2 * direction,
			"col": pieceIdx + 8 * 2 * direction
		},
		]
	else:
		return [
		{
			"row": 1 * direction,
			"col": pieceIdx + 8 * direction
		}
		]
