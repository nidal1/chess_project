extends StateBase

func enter(data=null):
	self.OnObservingTheClickingOnSquares()

func OnObservingTheClickingOnSquares() -> void:
	if not Constants.observingClickingOnSquares.is_connected(HandleClickingSquare):
		Constants.observingClickingOnSquares.connect(HandleClickingSquare)

func HandleClickingSquare(chessSquare):
	if not chessSquare.isEmpty:
		var piece = chessSquare.GetPiece()
		if piece is King:
			stateMachine.switchTo(Constants.STATES.GAME.SelectKingSquareState, chessSquare)
			return

	stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, chessSquare)
