extends StateBase

func enter(data = null):
	var nextSquare = data.nextSquare as ChessSquare
	var currentSquare = data.currentSquare as ChessSquare

	var isBetweenPawns = IsTheNextSquareBetweenTwoPawns(nextSquare, currentSquare)

	Constants.HandleMovePiece(nextSquare, currentSquare)

	if isBetweenPawns:
		SendEnPassantData(
			nextSquare.squareIdx,
			currentSquare.squareIdx
		)

	else:
		SendSwitchPlacesData(currentSquare, nextSquare)

	
	var piece = nextSquare.GetPiece()

	piece.isMoved = true

	if piece is Pawn and piece.IsThePieceReachesTheSides(piece):
		var promotedPawnData = {
			"pawn": piece,
			"targetSquare": nextSquare,
		}
		stateMachine.switchTo(Constants.STATES.RULES.PromoteAPawnState, promotedPawnData)
		return
		
	else:
		if piece is Pawn:
			Player.CurrentPlayer.playerPreviousPiece = piece

		Player.CurrentPlayer.playerPreviousPiece = nextSquare.GetPiece()
		Constants.SwitchPlayers()
		Constants.selectedSquare = null
		stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)
		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func exit():
	var isTheKingUnderAttack: bool = Constants.CheckIfTheKingIsUnderAttack(stateMachine.gameUI)

	# if isTheKingUnderAttack:
	# 	pass
	
	Constants.nextSquares = []
	Constants.targetSquares = []

	stateMachine.gameUI.ToggleShowHighlightCircles(false)
	if not Constants.theKingUnderAttackData.isTheKingUnderAttack:
		stateMachine.gameUI.ToggleShowHighlightRedCircles(false)
	stateMachine.gameUI.ToggleShowHighlightArrows(false)
	stateMachine.gameUI.ToggleShowHighlightSwapKingCircles(false)

	Constants.castlingData.nextSquares = []


func IsTheNextSquareBetweenTwoPawns(nextSquare, currentSquare):
	var leftSquare = Constants.GRID[nextSquare.squareIdx + 1]
	var rightSquare = Constants.GRID[nextSquare.squareIdx - 1]

	if ((not leftSquare.isEmpty) and (leftSquare.GetPiece() is Pawn)) or ((not rightSquare.isEmpty and (rightSquare.GetPiece() is Pawn))):
		var leftPawn: Pawn = leftSquare.GetPiece() if leftSquare.GetPiece() is Pawn else null
		var rightPawn: Pawn = rightSquare.GetPiece() if rightSquare.GetPiece() is Pawn else null

		if leftPawn:
			leftPawn = leftPawn if not Player.CheckRole(leftPawn.isFor) else null
		
		if rightPawn:
			rightPawn = rightPawn if not Player.CheckRole(rightPawn.isFor) else null

		if leftPawn or rightPawn:
			Constants.enPassantData.prevPawnSquareIdx = currentSquare.squareIdx
			Constants.enPassantData.leftPawn = leftPawn
			Constants.enPassantData.rightPawn = rightPawn
			return true

	return false


func SendEnPassantData(targetSquareIndex, pawnSquareIndex):
	var outgoingData = {
		operation = {
			service = "playing",
			type = "enpassant",
			data = {
				matchId = client.matchId,
				playerId = client.playerDictionary.info.id,
				targetSquareIndex = targetSquareIndex,
				pawnSquareIndex = pawnSquareIndex,
			}
		}
	}

	client.Send(JSON.stringify(outgoingData))

# func SendTheKingUnderAttackData(targetSquareIndex, pawnSquareIndex):


func SendSwitchPlacesData(currentSquare, nextSquare):
	var outgoingData = {
		operation = {
			service = "playing",
			type = "switchplace",
			data = {
				matchId = client.matchId,
				playerId = client.playerDictionary.info.id,
				selectedSquareIndex = currentSquare.squareIdx,
				nextSquareIndex = nextSquare.squareIdx
			}
		}
	}

	client.Send(JSON.stringify(outgoingData))