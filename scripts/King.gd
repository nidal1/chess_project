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

func IsTheKingUnderAttack() -> bool:
	var opponentPrevPieceNextPositions := []
	var row = self.LocalizationOfSelectedPiece()

	var positions = Player.NextPlayer.playerPreviousPiece.GetNextPositions()

	var isPositionsContainsKingIndex: bool = positions.nextPositions.filter(func(np): return np.nextCol == self.pieceIdx).size() > 0

	if isPositionsContainsKingIndex:
		return true
	return false

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
