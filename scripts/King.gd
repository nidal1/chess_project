extends ChessPiece

class_name King

var visualBlackKing = preload ("res://sceens/black_king.tscn")
var visualWhiteKing = preload ("res://sceens/white_king.tscn")

func _init(_pieceIdx, _isBlackPiece=true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackKing.instantiate()
	else:
		self.visual = visualWhiteKing.instantiate()
	self.pieceIdx = _pieceIdx
	self.pieceCost = 1
	self.withSpecialMovement = false

func OnCheckTheCheckRule(nextSquares):
	for square in nextSquares:
		if square.pieceType.pieceIdx == self.pieceIdx:
			var gameRules: GameRule = GameRule.new()
			gameRules.CheckRule.emit(square)

func GetTheNextPosition():
	return [{
		"row": 0,
		"col": pieceIdx + 1
	},
	{
		"row": 0,
		"col": pieceIdx - 1
	},
	{
		"row": 1,
		"col": pieceIdx + 8
	},
	{
		"row": 1,
		"col": pieceIdx + 8 + 1
	},
	{
		"row": 1,
		"col": pieceIdx + 8 - 1
	},
	{
		"row": - 1,
		"col": pieceIdx - 8
	},
	{
		"row": - 1,
		"col": pieceIdx - 8 + 1
	},
	{
		"row": - 1,
		"col": pieceIdx - 8 - 1
	},
	]
