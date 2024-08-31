extends ChessPiece

class_name Knight
var visualBlackKnight = preload("res://scenes/black_knight.tscn")
var visualWhiteKnight = preload("res://scenes/white_knight.tscn")

func _init(_pieceIdx, _isBlackPiece = true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.isFor = Constants.blackPlayerLabel
		self.visual = visualBlackKnight.instantiate()
	else:
		self.isFor = Constants.whitePlayerLabel
		self.visual = visualWhiteKnight.instantiate()
	self.pieceIdx = _pieceIdx
	self.pieceCost = 3
	self.withSpecialMovement = false

func GetNextCoordinates():
	return [ {
			"row": 1,
			"col": pieceIdx + 8 - 2
		},
		{
			"row": 1,
			"col": pieceIdx + 8 + 2
		},
		{
			"row": 2,
			"col": pieceIdx + 16 + 1
		},
		{
			"row": 2,
			"col": pieceIdx + 16 - 1
		},
		{
			"row": - 1,
			"col": pieceIdx - 8 - 2
		},
		{
			"row": - 1,
			"col": pieceIdx - 8 + 2
		},
		{
			"row": - 2,
			"col": pieceIdx - 16 - 1
		},
		{
			"row": - 2,
			"col": pieceIdx - 16 + 1
		},
	]
