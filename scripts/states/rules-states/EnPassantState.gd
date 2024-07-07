extends StateBase

func enter(data=null):
	var enPassantSquare: ChessSquare = Constants.GRID[Constants.enPassantData.prevPawnSquareIdx]

	var currentSquare: ChessSquare = data
	var pawn: Pawn = currentSquare.GetPiece()

	currentSquare.DetachPiece()

	enPassantSquare.AssignPiece(pawn)

	var opponentSquare: ChessSquare = Constants.GRID[Player.NextPlayer.playerPreviousPiece.pieceIdx]

	Player.NextPlayer.RemovePiece(opponentSquare.GetPiece())

	opponentSquare.DetachPiece()

	Constants.UpdatePlayerScore(
		stateMachine.gameUI.UpdateBlackScore,
		stateMachine.gameUI.UpdateWhiteScore
	)

	# stateMachine.gameUI.ToggleShowHighlightSwapKingCircles(true)

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func exit():
	Constants.SwitchPlayers()
	Constants.ClearData()
	stateMachine.gameUI.SetToInvisible()
	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)
