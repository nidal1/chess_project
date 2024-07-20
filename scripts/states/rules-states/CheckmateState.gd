extends StateBase

# when to checkmate?
# if the king is under attack and :
	# the king has no possible square to move on
	# the king has no target position to take it place
	# you cannot take the place of the piece that targeting the king or switching to a one of the squares directed from queen, rook or bishop to the king

var specialMovementPiecePositionsTowardTheKing = []

func enter(data=null):
	Constants.checkmateData.checkmateChecked = true
	var king: King = Constants.checkmateData.king

	if Constants.checkmateData.nextPositions.size() > 0:
		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
		return

	if Constants.checkmateData.targetPositions.size() > 0:
		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
		return

	var piece: ChessPiece = FindThePieceThatTargetingThisPiece(Player.NextPlayer, king)

	if piece == null:
		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
		return
	else:
		if piece.withSpecialMovement and specialMovementPiecePositionsTowardTheKing.size() > 0:
			if CanSwitchToOneOfTheSpecialMovementPiecePositions(king):
				stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
				return

	var ownPiece: ChessPiece = FindThePieceThatTargetingThisPiece(Player.CurrentPlayer, piece)

	if ownPiece != null:
		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
		return

	stateMachine.gameUI.UpdatePlayerWinning(Player.NextPlayer.playerLabel)

func FindThePieceThatTargetingThisPiece(player: Player, piece: ChessPiece) -> ChessPiece:
	var piecePosition = piece.pieceIdx

	for op in player.playerPieces:
		var positions = []
		var p = op as ChessPiece
		if p.withSpecialMovement:
			positions = p.GetNextPositions().nextPositions
			positions = Constants.FilterBlockedDirectionsAndReturnPositions(positions, p)
			specialMovementPiecePositionsTowardTheKing.append(positions)
		elif p is King:
			positions = p.GetNextPositions().nextPositions
			positions = p.FilterPositionByOtherPiecesPositions(positions)
		else:
			positions = p.GetAllOppositePiecePositions().nextPositions if p is Pawn else p.GetNextPositions().nextPositions

		var test = positions.filter(func(pos): return pos.nextCol == piecePosition)
		if test.size() > 0:
			return p

	return null

func CanSwitchToOneOfTheSpecialMovementPiecePositions(king: King):
	var isExist = false
	for position in specialMovementPiecePositionsTowardTheKing:
		
		# var direction = position.filter(func(p): return p.nextCol == king.pieceIdx)[0].direction if position.size() > 0 else - 1
		var targetDirection = position.filter(func(p): return p.nextCol == king.pieceIdx)
		if targetDirection.size() > 0:
			var direction = targetDirection[0].direction
			if direction >= 0:
				var targetP = position.filter(func(p): return p.direction == direction)

				for tp in targetP:
					for piece in Player.CurrentPlayer.playerPieces:
						var ownPositions = []
						piece = piece as ChessPiece
						if piece.withSpecialMovement:
							ownPositions = piece.GetNextPositions().nextPositions
							ownPositions = Constants.FilterBlockedDirectionsAndReturnPositions(ownPositions, piece)
						elif piece is King:
							ownPositions = piece.GetNextPositions().nextPositions
							ownPositions = piece.FilterPositionByOtherPiecesPositions(ownPositions)
						else:
							ownPositions = piece.GetNextPositions().nextPositions
						
						var test = ownPositions.filter(func(op): return op.nextCol == tp.nextCol)
						if test.size() > 0:
							isExist = true
							break

	return isExist
