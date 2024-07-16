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

	var positions = Player.NextPlayer.playerPreviousPiece.GetNextPositions()

	var isPiecePositionsContainsKingIndex: bool = positions.nextPositions.filter(func(np): return np.nextCol == self.pieceIdx).size() > 0

	if isPiecePositionsContainsKingIndex:
		return true

	var opponentNextPositions = []
	for op in Player.NextPlayer.playerPieces:
		var p: ChessPiece = op as ChessPiece
		opponentNextPositions.append(p.GetNextPositions().nextPositions)
	
	for onp in opponentNextPositions:
		if onp.filter(func(np): return np.nextCol == self.pieceIdx).size() > 0:
			isPiecePositionsContainsKingIndex = true
			
	return isPiecePositionsContainsKingIndex

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
