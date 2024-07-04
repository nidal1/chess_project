extends StateBase

func enter(data=null):
	self.OnObservingTheClickingOnSquares()

func OnObservingTheClickingOnSquares() -> void:
	if not Constants.observingClickingOnSquares.is_connected(HandleClickingSquare):
		Constants.observingClickingOnSquares.connect(HandleClickingSquare)

func HandleClickingSquare(chessSquare):
	stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, chessSquare)
