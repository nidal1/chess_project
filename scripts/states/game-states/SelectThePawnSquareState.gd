extends StateBase

func enter(data=""):

	var square: ChessSquare = data

	CheckForEnPassantState(square)
	
	stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, data)

func CheckForEnPassantState(square: ChessSquare):
	if (Player.NextPlayer.playerPreviousPiece != null) and (Player.NextPlayer.playerPreviousPiece is Pawn) and Constants.enPassantData.prevPawnSquareIdx >= 0:
		var pawn: Pawn = square.GetPiece()
		if (pawn == Constants.enPassantData.leftPawn) or (pawn == Constants.enPassantData.rightPawn):
			var enPassantSquare = Constants.GRID[Constants.enPassantData.prevPawnSquareIdx]

			Constants.enPassantData.nextSquare = enPassantSquare

			stateMachine.gameUI.visibleHighlightSwapPawnCircle = enPassantSquare

			stateMachine.gameUI.ToggleShowHighlightSwapPawnCircle(true)

			stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, square)