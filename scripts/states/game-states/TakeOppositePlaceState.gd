extends StateBase

func enter(data=null):
	var nextSquare = data.nextSquare as ChessSquare
	var currentSquare = data.currentSquare as ChessSquare
	var removedPiece = TakePlaceOfOpponentPiece(nextSquare, currentSquare)
	Player.NextPlayer.RemovePiece(removedPiece)

	Constants.UpdatePlayerScore(
		stateMachine.gameUI.UpdateBlackScore,
		stateMachine.gameUI.UpdateWhiteScore
	)

	Player.CurrentPlayer.playerPreviousPiece = nextSquare.GetPiece()

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func exit():
	Constants.SwitchPlayers()
	var king: King = Player.NextPlayer.playerPieces.filter(GetTheKing)[0]
	
	king.IsTheKingUnderAttack()
	Constants.selectedSquare = null
	Constants.nextSquares = []
	Constants.targetSquares = []

	stateMachine.gameUI.ToggleShowHighlightCircles(false)
	stateMachine.gameUI.ToggleShowHighlightArrows(false)
	stateMachine.gameUI.ToggleShowHighlightSwapKingCircles(false)

	Constants.castlingData.nextSquares = []

	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

func GetTheKing(p: ChessPiece):
	return p if p is King else null

func TakePlaceOfOpponentPiece(nextSquare: ChessSquare, selectedSquare: ChessSquare) -> ChessPiece:

	var selectedPiece = selectedSquare.GetPiece()
	var removedPiece = nextSquare.GetPiece()
	selectedSquare.DetachPiece()
	nextSquare.DetachPiece()
	nextSquare.AssignPiece(selectedPiece)
	selectedPiece.pieceIdx = nextSquare.squareIdx
	selectedPiece.isMoved = true
	return removedPiece
