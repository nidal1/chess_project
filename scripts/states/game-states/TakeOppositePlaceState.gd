extends StateBase

func enter(data = null):
	var nextSquare = data.nextSquare as ChessSquare
	var currentSquare = data.currentSquare as ChessSquare
	var removedPiece = Constants.TakePlaceOfOpponentPiece(nextSquare, currentSquare)
	Player.NextPlayer.RemovePiece(removedPiece)

	Constants.UpdatePlayerScore(
		stateMachine.gameUI.UpdateBlackScore,
		stateMachine.gameUI.UpdateWhiteScore
	)

	Player.CurrentPlayer.playerPreviousPiece = nextSquare.GetPiece() if nextSquare.GetPiece() != removedPiece else null

	SendTakeOppositePlaceData(currentSquare, nextSquare)

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func exit():

	Constants.SwitchPlayers()
	Constants.CheckIfTheKingIsUnderAttack(stateMachine.gameUI)

	Constants.selectedSquare = null
	Constants.nextSquares = []
	Constants.targetSquares = []

	stateMachine.gameUI.ToggleShowHighlightCircles(false)
	if not Constants.theKingUnderAttackData.isTheKingUnderAttack:
		stateMachine.gameUI.ToggleShowHighlightRedCircles(false)
	stateMachine.gameUI.ToggleShowHighlightArrows(false)
	stateMachine.gameUI.ToggleShowHighlightSwapKingCircles(false)

	Constants.castlingData.nextSquares = []

	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)


func GetTheKing(p: ChessPiece):
	return p if p is King else null


func SendTakeOppositePlaceData(currentSquare, nextSquare):
	var outgoingData = {
		operation = {
			service = "playing",
			type = "takeoppositeplace",
			data = {
				matchId = client.matchId,
				playerId = client.playerDictionary.info.id,
				selectedSquareIndex = currentSquare.squareIdx,
				nextSquareIndex = nextSquare.squareIdx
			}
		}
	}

	client.Send(JSON.stringify(outgoingData))