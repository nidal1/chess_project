extends StateBase

func enter(data=null):
	
	# on the king under attack:
		# 1. think to remove the piece (the last played piece) that attacking the king
		# 2. this to move the king to the safe position:
			# 2.1. by taking the place of an opponent piece
			# 2.2. by switching the place to an empty square

	var pieceType
	var playerRolePiece

	# get the clicked square
	var square = data as ChessSquare
	
	if not square.isEmpty:
		var piece: ChessPiece = square.GetPiece()
		pieceType = piece.isFor
		
		playerRolePiece = Player.CheckRole(pieceType)

		if ((piece == Player.NextPlayer.playerPreviousPiece) or playerRolePiece):
			# this case means the king is under attack and you are targeting a opponent piece that will remove
			# the check rule
			stateMachine.gameUI.ToggleShowHighlightCircles(false)
			stateMachine.gameUI.ToggleShowHighlightArrows(false)
			stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, square)
			return
		
		if (Constants.theKingUnderAttackData.targetSquares.has(square)):
			# this case means that this square is for a king target
			Constants.targetSquares.append(square)
			Constants.theKingUnderAttackData.isTheKingUnderAttack = false
			stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, square)
			return
		
		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
		return

	else:
		if Constants.theKingUnderAttackData.nextSquares.has(square):
			Constants.nextSquares = Constants.theKingUnderAttackData.nextSquares
			Constants.theKingUnderAttackData.isTheKingUnderAttack = false
			stateMachine.gameUI.ToggleShowHighlightRedCircles(false)
			stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, square)

		if Constants.theKingUnderAttackData.withSpecialMovementPieceTargetPositionsToTheKing.has(square):
			Constants.nextSquares = Constants.theKingUnderAttackData.withSpecialMovementPieceTargetPositionsToTheKing
			Constants.theKingUnderAttackData.isTheKingUnderAttack = false
			stateMachine.gameUI.ToggleShowHighlightRedCircles(false)
			stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, square)

func SelectOnlyPermittedSquare() -> void:
	# get the type of the current piece
	var piece: King = Constants.selectedSquare.GetPiece()
	
	var nextCoordinates = piece.GetNextPositions()
	var nextPositions = piece.filterPositionByOtherPiecesPositions(nextCoordinates.nextPositions)
	
	Constants.theKingUnderAttackData.nextSquares = FilterSimilarPieces(nextPositions, piece)

	Constants.theKingUnderAttackData.targetSquares = GetAllOppositePieces(Constants.theKingUnderAttackData.nextSquares, piece)

	stateMachine.gameUI.visibleHighlightArrows = Constants.theKingUnderAttackData.targetSquares
	stateMachine.gameUI.visibleHighlightCircles = Constants.theKingUnderAttackData.nextSquares
	stateMachine.gameUI.ToggleShowHighlightArrows(true)
	stateMachine.gameUI.ToggleShowHighlightCircles(true)

func FilterSimilarPieces(nextPositions, chessPiece) -> Array[ChessSquare]:
	var nextSquares: Array[ChessSquare] = []
	for pos in nextPositions:
		var nextSquare = Constants.GRID[pos.nextCol]
		if not nextSquare.isEmpty and nextSquare.pieceType.CanMove(chessPiece):
			nextSquares.append(nextSquare)
		if nextSquare.isEmpty:
			nextSquares.append(nextSquare)
	
	return nextSquares

func GetAllOppositePieces(_nextSquares, piece) -> Array[ChessSquare]:
	var _targetSquares: Array[ChessSquare] = []
	for square in _nextSquares:
		if not square.isEmpty:
			if not AreThePiecesTheSameColor(piece, square.pieceType):
				_targetSquares.append(square)

	return _targetSquares

func AreThePiecesTheSameColor(p1: ChessPiece, p2: ChessPiece) -> bool:
	return int(p1.isBlackPiece) + int(p2.isBlackPiece) == 2
