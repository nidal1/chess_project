extends StateBase

func enter(data=null):
	# check if the square is of the player role or not

	var pieceType
	var playerRole

	# get the clicked square
	var square = data as ChessSquare
	var king: King = square.GetPiece()
	
	pieceType = king.isFor

	# then check the role to determine whether we should setting the selected square variable or not.
	# The selected square should be set only if the current clicked square contains the piece and for the current
	# player role._add_constant_force
	playerRole = Player.CheckRole(pieceType)

	# this if statement means that the clicked square is for the current player role
	if playerRole:
		Constants.selectedSquare = square
		if not stateMachine.gameUI.visibleHighlightArrows.has(Constants.selectedSquare):
			stateMachine.gameUI.ClearHighlightArrows()
			stateMachine.gameUI.ClearHighlightCircles(Constants.selectedSquare)
		
		SelectOnlyPermittedSquare()
		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
		return

func SelectOnlyPermittedSquare() -> void:
	# get the type of the current piece
	var piece: King = Constants.selectedSquare.GetPiece()
	
	var nextCoordinates = piece.GetNextPositions()
	var nextPositions = nextCoordinates.nextPositions

	# filter
	nextPositions = filterPositionByOtherPiecesPositions(nextPositions)
	
	Constants.nextSquares = FilterSimilarPieces(nextPositions, piece)

	Constants.targetSquares = GetAllOppositePieces(Constants.nextSquares, piece)

	stateMachine.gameUI.visibleHighlightArrows = Constants.targetSquares
	stateMachine.gameUI.visibleHighlightCircles = Constants.nextSquares
	stateMachine.gameUI.ToggleShowHighlightArrows(true)
	stateMachine.gameUI.ToggleShowHighlightCircles(true)

func filterPositionByOtherPiecesPositions(nextPositions):
	var opponentPieces: Array = Player.NextPlayer.playerPieces
	for op in opponentPieces:
		var piece = op as ChessPiece
		var positions = piece.GetNextPositions()
		for pos in positions.nextPositions:
			nextPositions = nextPositions.filter(func(np): return np.nextCol != pos.nextCol)
	return nextPositions

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
