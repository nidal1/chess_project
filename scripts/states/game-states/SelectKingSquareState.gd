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

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func HandleSelectAvailableRooks(squareIdx):
	var square: ChessSquare = Constants.GRID[squareIdx]
	Constants.nextSquaresToSwapTheKingTo.append(square)
	
	stateMachine.gameUI.visibleHighlightSwapCircles = Constants.nextSquaresToSwapTheKingTo
	stateMachine.gameUI.ToggleShowHighlightSwapKingCircles(true)
