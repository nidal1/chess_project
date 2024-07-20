extends StateBase

func enter(data=null):
	if Constants.theKingUnderAttackData.isTheKingUnderAttack and not Constants.checkmateData.checkmateChecked:
		Constants.observingClickingOnSquares.disconnect(HandleClickingSquare)
		stateMachine.switchTo(Constants.STATES.RULES.CheckmateState)
		return
		
	else: self.OnObservingTheClickingOnSquares()

func OnObservingTheClickingOnSquares() -> void:
	if not Constants.observingClickingOnSquares.is_connected(HandleClickingSquare):
		Constants.observingClickingOnSquares.connect(HandleClickingSquare)

func HandleClickingSquare(chessSquare):
	if Constants.theKingUnderAttackData.isTheKingUnderAttack:
			stateMachine.switchTo(Constants.STATES.RULES.KingUnderAttackState, chessSquare)
			return

	if not chessSquare.isEmpty:
		var piece = chessSquare.GetPiece()

		if (not piece is King) and (Constants.theKingUnderAttackData.isTheKingUnderAttack):
			return

		if piece is Pawn:
			stateMachine.switchTo(Constants.STATES.GAME.SelectThePawnSquareState, chessSquare)
			return

		if piece is King and not piece.isMoved:
			stateMachine.switchTo(Constants.STATES.GAME.SelectKingSquareState, chessSquare)
			return

	stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, chessSquare)
