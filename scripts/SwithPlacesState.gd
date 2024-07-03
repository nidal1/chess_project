extends StateBase

func enter(data=null):
	var nextSquare = data.nextSquare as ChessSquare
	var currentSquare = data.currentSquare as ChessSquare
	HandleMovePiece(nextSquare, currentSquare)
	stateMachine.switchTo("WaitingState")

func exit():
	Constants.SwitchPlayers()
	Constants.selectedSquare = null
	Constants.nextSquares = []
	Constants.targetSquares = []
	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

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
