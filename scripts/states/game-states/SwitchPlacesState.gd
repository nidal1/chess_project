extends StateBase

func enter(data=null):
	var nextSquare = data.nextSquare as ChessSquare
	var currentSquare = data.currentSquare as ChessSquare
	
	HandleMovePiece(nextSquare, currentSquare)

	var piece = nextSquare.GetPiece()

	piece.isMoved = true

	if piece is Pawn and stateMachine.gameRules.IsThePieceReachesTheSides(piece):
		var promotedPawnData = {
			"pawn": piece,
			"targetSquare": nextSquare,
		}
		stateMachine.switchTo(Constants.STATES.RULES.PromoteAPawnState, promotedPawnData)
		return
		
	else:
		Constants.SwitchPlayers()
		Constants.selectedSquare = null
		stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)
		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func exit():
	
	Constants.nextSquares = []
	Constants.targetSquares = []

	stateMachine.gameUI.ToggleShowHighlightCircles(false)
	stateMachine.gameUI.ToggleShowHighlightArrows(false)
	stateMachine.gameUI.ToggleShowHighlightSwapKingCircles(false)

	Constants.nextSquaresToSwapTheKingTo = []

func HandleMovePiece(nextSquare: ChessSquare, _selectedSquare: ChessSquare) -> void:
	var selectedPiece = _selectedSquare.pieceType
	selectedPiece.pieceIdx = nextSquare.squareIdx
	_selectedSquare.DetachPiece()
	nextSquare.AssignPiece(selectedPiece)
	if selectedPiece is Pawn:
		selectedPiece.isTheFirstMove = false
