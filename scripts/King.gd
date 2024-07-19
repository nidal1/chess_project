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

func FilterPositionByOtherPiecesPositions(nextPositions):
	var positions
	var opponentPieces: Array = Player.NextPlayer.playerPieces
	for op in opponentPieces:
		var piece = op as ChessPiece
		if piece.withSpecialMovement:
			positions = piece.GetNextPositions().nextPositions
			positions = Constants.FilterBlockedDirectionsAndReturnPositions(positions, piece)
		else:
			positions = piece.GetAllOppositePiecePositions().nextPositions if piece is Pawn else piece.GetNextPositions().nextPositions
		
		for pos in positions:
			nextPositions = nextPositions.filter(func(np): return np.nextCol != pos.nextCol)

	return nextPositions

func IsTheKingUnderAttack() -> bool:
	var isPiecePositionsContainsKingIndex = false
	var opponentNextPositions = []
	for op in Player.NextPlayer.playerPieces:
		var p: ChessPiece = op as ChessPiece
		if p.withSpecialMovement:

			var positions = p.GetNextPositions().nextPositions
			positions = Constants.FilterBlockedDirectionsAndReturnPositions(positions, p)
			for pos in positions:
				var test = pos.nextCol == self.pieceIdx
				if test:
					var targetDirection = pos.direction
					var targetP = positions.filter(func(p): return p.direction == targetDirection)
					for tp in targetP:
						if tp.nextCol == self.pieceIdx:
							break
						Constants.theKingUnderAttackData.withSpecialMovementPieceTargetPositionsToTheKing.append(Constants.GRID[tp.nextCol])

					isPiecePositionsContainsKingIndex = true
					break
			
			if isPiecePositionsContainsKingIndex:
				return true

		else:
			opponentNextPositions.append(p.GetAllOppositePiecePositions().nextPositions if p is Pawn else p.GetNextPositions().nextPositions)
	
	for onp in opponentNextPositions:
		var test = onp.filter(func(np): return np.nextCol == self.pieceIdx)
		if test.size() > 0:
			isPiecePositionsContainsKingIndex = true
	
	return isPiecePositionsContainsKingIndex
