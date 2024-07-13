extends ChessPiece

class_name King

var visualBlackKing = preload ("res://sceens/black_king.tscn")
var visualWhiteKing = preload ("res://sceens/white_king.tscn")

func _init(_pieceIdx, _isBlackPiece=true):
	self.isBlackPiece = _isBlackPiece
	if self.isBlackPiece:
		self.visual = visualBlackKing.instantiate()
		self.isFor = Constants.blackPlayerLabel
	else:
		self.visual = visualWhiteKing.instantiate()
		self.isFor = Constants.whitePlayerLabel

	self.pieceIdx = _pieceIdx
	self.pieceCost = 1
	self.withSpecialMovement = false

func IsTheKingUnderAttack():
	var opponentPrevPieceNextPositions := []
	var row = self.LocalizationOfSelectedPiece()
	print(row)
	var coordinates = Player.NextPlayer.playerPreviousPiece.GetNextCoordinates()
	
	coordinates = coordinates.filter(func(coor): return coor.col >= 0 and coor.col < Constants.COLS * Constants.ROWS)

func GetNextCoordinates():
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

func GetSquaresNeededToBeEmptyToSwapWithRooks() -> Array:
	return [
		[
			{
				"row": 0,
				"col": pieceIdx - 1
			},
			{
				"row": 0,
				"col": pieceIdx - 2
			}
		],
		[
			{
				"row": 0,
				"col": pieceIdx + 1
			},
			{
				"row": 0,
				"col": pieceIdx + 2
			},
			{
				"row": 0,
				"col": pieceIdx + 3
			}
		],
		{
			"rightRook": pieceIdx - 3,
			"leftRook": pieceIdx + 4
		}
	]
