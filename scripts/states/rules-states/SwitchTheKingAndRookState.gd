extends StateBase

func enter(data=null):
	var square: ChessSquare = data

	var rook: Rook = null
	var theRookNextPos

	var king: King = Constants.selectedSquare.GetPiece()

	var coordinates = king.GetSquaresNeededToBeEmptyToSwapWithRooks()

	for coor in coordinates[0]:
		if Constants.GRID[coor.col].squareIdx == square.squareIdx:
			rook = Constants.castlingData.rightRook
			theRookNextPos = coordinates[0][0].col
	
	for coor in coordinates[1]:
		if Constants.GRID[coor.col].squareIdx == square.squareIdx:
			rook = Constants.castlingData.leftRook
			theRookNextPos = coordinates[1][1].col

	# swap the king
	Constants.selectedSquare.DetachPiece()
	square.AssignPiece(king)

	Constants.GRID[rook.pieceIdx].DetachPiece()
	Constants.GRID[theRookNextPos].AssignPiece(rook)

	king.isMoved = true
	rook.isMoved = true

	Player.CurrentPlayer.playerPreviousPiece = king

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func exit():

	Constants.SwitchPlayers()
	Constants.ClearData()
	
	stateMachine.gameUI.SetToInvisible()

	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)
