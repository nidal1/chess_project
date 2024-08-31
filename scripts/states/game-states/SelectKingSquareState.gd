extends StateBase

func enter(data=""):

	var pieceType
	var playerRole

	# get the clicked square
	var square = data as ChessSquare
	var king: King = square.GetPiece()
	
	if king.isBlackPiece:
		pieceType = Constants.blackPlayerLabel
	else:
		pieceType = Constants.whitePlayerLabel

	playerRole = Player.CheckRole(pieceType)

	if playerRole:
		if Constants.theKingUnderAttackData.isTheKingUnderAttack:
			Constants.selectedSquare = square
			if not stateMachine.gameUI.visibleHighlightArrows.has(Constants.selectedSquare):
				stateMachine.gameUI.ClearHighlightArrows()
				stateMachine.gameUI.ClearHighlightCircles(Constants.selectedSquare)
			
			SelectOnlyPermittedSquare(king)
			stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
			return
		
		else:
			CheckForCastling(king, pieceType, square)
			SelectOnlyPermittedSquare(king)
			stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
			return

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func HandleSelectAvailableRooks(squareIdx):
	var square: ChessSquare = Constants.GRID[squareIdx]
	Constants.castlingData.nextSquares.append(square)
	
	stateMachine.gameUI.visibleHighlightSwapKingCircles = Constants.castlingData.nextSquares
	stateMachine.gameUI.ToggleShowHighlightSwapKingCircles(true)

func CheckForCastling(king: King, pieceType, square):
	if not Constants.theKingUnderAttackData.isTheKingUnderAttack:
		var allRightSquaresAreEmpty: bool = true
		var allLeftSquaresAreEmpty: bool = true

		var coordinates = king.GetSquaresNeededToBeEmptyToSwapWithRooks()
		# Right and Left squares that are probably the rook's squares
		var rightSquareForTheRook: ChessSquare = Constants.GRID[coordinates[2].rightRook]
		var leftSquareForTheRook: ChessSquare = Constants.GRID[coordinates[2].leftRook]

		# checking for the right rook
		var isTheRightRookForCurrentPlayerRole: bool = false
		var isTheLeftRookForCurrentPlayerRole: bool = false

		if not rightSquareForTheRook.isEmpty:
			var rightRook: Rook
			if rightSquareForTheRook.GetPiece() is Rook:
				rightRook = rightSquareForTheRook.GetPiece()
				var isTheRightRookExistAndNotMovedYet = not rightRook.isMoved
				isTheRightRookForCurrentPlayerRole = isTheRightRookExistAndNotMovedYet and rightRook.isFor == pieceType

		if not leftSquareForTheRook.isEmpty:
			var leftRook: Rook
			if leftSquareForTheRook.GetPiece() is Rook:
				leftRook = leftSquareForTheRook.GetPiece()
				var isTheLeftRookExistAndNotMovedYet = not leftRook.isMoved
				isTheLeftRookForCurrentPlayerRole = isTheLeftRookExistAndNotMovedYet and leftRook.isFor == pieceType
		
		if isTheRightRookForCurrentPlayerRole:
			for coor in coordinates[0]:
				var nextSquare: ChessSquare = Constants.GRID[coor.col]
				if not nextSquare.isEmpty:
					allRightSquaresAreEmpty = false
				
			if allRightSquaresAreEmpty:
				HandleSelectAvailableRooks(coordinates[0][1].col)
				Constants.castlingData.rightRook = rightSquareForTheRook.GetPiece() as Rook

		if isTheLeftRookForCurrentPlayerRole:
			for coor in coordinates[1]:
				var nextSquare: ChessSquare = Constants.GRID[coor.col]
				if not nextSquare.isEmpty:
					allLeftSquaresAreEmpty = false
			
			if allLeftSquaresAreEmpty:
				HandleSelectAvailableRooks(coordinates[1][2].col)
				Constants.castlingData.leftRook = leftSquareForTheRook.GetPiece() as Rook

		stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, square)

	return

func SelectOnlyPermittedSquare(king: King) -> void:
	
	var nextCoordinates = king.GetNextPositions()
	var nextPositions = king.FilterPositionByOtherPiecesPositions(nextCoordinates.nextPositions)
	Constants.theKingUnderAttackData.nextSquares = Constants.FilterSimilarPieces(nextPositions, king)

	Constants.theKingUnderAttackData.targetSquares = Constants.GetAllOppositePieces(Constants.theKingUnderAttackData.nextSquares, king)

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
