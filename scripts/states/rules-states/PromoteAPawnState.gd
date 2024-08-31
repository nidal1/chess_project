extends StateBase

var pawn: Pawn = null
var targetSquare: ChessSquare = null
var promoteAPawnIdx: int

func enter(data = null):
	pawn = data.pawn
	targetSquare = data.targetSquare as ChessSquare
	promoteAPawnIdx = targetSquare.squareIdx
	PromoteAPawn()


func PromoteAPawn() -> void:
	if pawn.IsThePieceReachesTheSides(pawn):
		if pawn.isBlackPiece:
			stateMachine.gameUI.ToggleBlackHPassantContainer()
		else:
			stateMachine.gameUI.ToggleWhiteHPassantContainer()

func SelectPromotedPiece(promotedPiece: ChessPiece):
	Player.CurrentPlayer.RemovePiece(pawn)
	
	targetSquare.DetachPiece()
	targetSquare.AssignPiece(promotedPiece)

	Player.CurrentPlayer.AppendPiece(promotedPiece)

	Player.CurrentPlayer.playerPreviousPiece = promotedPiece

	if promotedPiece.isBlackPiece:
		stateMachine.gameUI.ToggleBlackHPassantContainer()
	else:
		stateMachine.gameUI.ToggleWhiteHPassantContainer()

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func exit():
	
	Constants.SwitchPlayers()
		
	Constants.UpdatePlayerScore(
		stateMachine.gameUI.UpdateBlackScore,
		stateMachine.gameUI.UpdateWhiteScore
	)
	Constants.selectedSquare = null
	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

func _on_white_queen_promoted_button_pressed():
	var queen = Queen.new(promoteAPawnIdx, false)
	SelectPromotedPiece(queen)
	SendPromoteAPawnData("queen", promoteAPawnIdx, Constants.whitePlayerLabel)

func _on_white_bishop_promoted_button_pressed():
	var bishop = Bishop.new(promoteAPawnIdx, false)
	SelectPromotedPiece(bishop)
	SendPromoteAPawnData("bishop", promoteAPawnIdx, Constants.whitePlayerLabel)

func _on_white_knight_promoted_button_pressed():
	var knight = Knight.new(promoteAPawnIdx, false)
	SelectPromotedPiece(knight)
	SendPromoteAPawnData("knight", promoteAPawnIdx, Constants.whitePlayerLabel)

func _on_white_rook_promoted_button_pressed():
	var rook = Rook.new(promoteAPawnIdx, false)
	SelectPromotedPiece(rook)
	SendPromoteAPawnData("rook", promoteAPawnIdx, Constants.whitePlayerLabel)

func _on_black_queen_promoted_button_pressed():
	var queen = Queen.new(promoteAPawnIdx)
	SelectPromotedPiece(queen)
	SendPromoteAPawnData("queen", promoteAPawnIdx, Constants.blackPlayerLabel)

func _on_black_bishop_promoted_button_pressed():
	var bishop = Bishop.new(promoteAPawnIdx)
	SelectPromotedPiece(bishop)
	SendPromoteAPawnData("bishop", promoteAPawnIdx, Constants.blackPlayerLabel)

func _on_black_knight_promoted_button_pressed():
	var knight = Knight.new(promoteAPawnIdx)
	SelectPromotedPiece(knight)
	SendPromoteAPawnData("knight", promoteAPawnIdx, Constants.blackPlayerLabel)

func _on_black_rook_promoted_button_pressed():
	var rook = Rook.new(promoteAPawnIdx)
	SelectPromotedPiece(rook)
	SendPromoteAPawnData("rook", promoteAPawnIdx, Constants.blackPlayerLabel)


func SendPromoteAPawnData(promotedPiece, promotedPieceIndex, role):
	var outgoingData = {
		operation = {
			service = "playing",
			type = "promotepawn",
			data = {
				matchId = client.matchId,
				playerId = client.playerDictionary.info.id,
				promotedPiece = promotedPiece,
				promotedPieceIndex = promotedPieceIndex,
				role = role
			}
		}
	}

	client.Send(JSON.stringify(outgoingData))