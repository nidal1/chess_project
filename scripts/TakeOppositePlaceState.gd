extends StateBase

func enter(data=null):
    var nextSquare = data.nextSquare as ChessSquare
    var currentSquare = data.currentSquare as ChessSquare
    var removedPiece = TakePlaceOfOpponentPiece(nextSquare, currentSquare)
    if Player.NextPlayer.playerLabel == Constants.blackPlayerLabel:
        var score = Player.NextPlayer.playerScore - removedPiece.pieceCost
        Player.NextPlayer.playerScoreObserver.emit(score, stateMachine.gameUI.UpdateBlackScore)
    else:
        var score = Player.NextPlayer.playerScore - removedPiece.pieceCost
        Player.NextPlayer.playerScoreObserver.emit(score, stateMachine.gameUI.UpdateWhiteScore)
    stateMachine.switchTo("WaitingState")

func exit():
    Constants.SwitchPlayers()
    Constants.selectedSquare = null
    Constants.nextSquares = []
    Constants.targetSquares = []
    stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

func TakePlaceOfOpponentPiece(nextSquare: ChessSquare, selectedSquare: ChessSquare) -> ChessPiece:
    stateMachine.gameUI.ToggleShowHighlightCircles(false)
    stateMachine.gameUI.ToggleShowHighlightArrows(false)
    var selectedPiece = selectedSquare.GetPiece()
    var removedPiece = nextSquare.GetPiece()
    selectedSquare.DetachPiece()
    nextSquare.DetachPiece()
    nextSquare.AssignPiece(selectedPiece)
    selectedPiece.pieceIdx = nextSquare.squareIdx
    return removedPiece