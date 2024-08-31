extends StateBase

func enter(data = null):

	var currentSquare: ChessSquare = data
	var pawn: Pawn = currentSquare.GetPiece()

	var enPassantSquare: ChessSquare = Constants.GRID[Constants.enPassantData.prevPawnSquareIdx]
	var opponentSquare: ChessSquare = Constants.GRID[Player.NextPlayer.playerPreviousPiece.pieceIdx]

	Constants.TakeEnPassantPlace(currentSquare, enPassantSquare, opponentSquare, pawn)

	SendTakeEnPassantPlaceData(currentSquare, enPassantSquare, opponentSquare)

	Constants.UpdatePlayerScore(
		stateMachine.gameUI.UpdateBlackScore,
		stateMachine.gameUI.UpdateWhiteScore
	)

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func exit():

	Constants.SwitchPlayers()
	Constants.ClearData()
	stateMachine.gameUI.SetToInvisible()
	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)


func SendTakeEnPassantPlaceData(currentSquare, nextSquare, targetSquareIndex):
	var outgoingData = {
		operation = {
			service = "playing",
			type = "takeenpassantplace",
			data = {
				matchId = client.matchId,
				playerId = client.playerDictionary.info.id,
				selectedSquareIndex = currentSquare.squareIdx,
				nextSquareIndex = nextSquare.squareIdx,
				targetSquareIndex = targetSquareIndex.squareIdx
			}
		}
	}

	client.Send(JSON.stringify(outgoingData))