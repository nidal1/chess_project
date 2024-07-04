extends StateBase

func enter(data=null):
	var nextSquare = data.nextSquare as ChessSquare
	var currentSquare = data.currentSquare as ChessSquare
	
	HandleMovePiece(nextSquare, currentSquare)

	var piece = nextSquare.GetPiece()
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

func HandleMovePiece(nextSquare: ChessSquare, _selectedSquare: ChessSquare) -> void:
	stateMachine.gameUI.ToggleShowHighlightCircles(false)
	stateMachine.gameUI.ToggleShowHighlightArrows(false)
	var selectedPiece = _selectedSquare.pieceType
	selectedPiece.pieceIdx = nextSquare.squareIdx
	_selectedSquare.DetachPiece()
	nextSquare.AssignPiece(selectedPiece)
	if selectedPiece is Pawn:
		selectedPiece.isTheFirstMove = false
		# if stateMachine.gameRules.IsThePieceReachesTheSides(selectedPiece):
		# 	stateMachine.gameRules.PromoteAPawn(selectedPiece, nextSquare)
