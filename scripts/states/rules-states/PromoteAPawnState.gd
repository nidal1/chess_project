extends StateBase

var pawn: Pawn = null
var targetSquare: ChessSquare = null
var promoteAPawnIdx: int

func enter(data=null):
	pawn = data.pawn
	targetSquare = data.targetSquare as ChessSquare
	promoteAPawnIdx = targetSquare.squareIdx
	PromoteAPawn()

func PromoteAPawn() -> void:
	if stateMachine.gameRules.IsThePieceReachesTheSides(pawn):
		if pawn.isBlackPiece:
			stateMachine.gameUI.ToggleBlackHPassantContainer()
		else:
			stateMachine.gameUI.ToggleWhiteHPassantContainer()

func SelectPromotedPiece(promotedPiece: ChessPiece):
	Player.CurrentPlayer.RemovePiece(pawn)
	
	targetSquare.DetachPiece()
	targetSquare.AssignPiece(promotedPiece)

	Player.CurrentPlayer.AppendPiece(promotedPiece)

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

func _on_white_bishop_promoted_button_pressed():
	var bishop = Bishop.new(promoteAPawnIdx, false)
	SelectPromotedPiece(bishop)

func _on_white_knight_promoted_button_pressed():
	var knight = Knight.new(promoteAPawnIdx, false)
	SelectPromotedPiece(knight)

func _on_white_rook_promoted_button_pressed():
	var rook = Rook.new(promoteAPawnIdx, false)
	SelectPromotedPiece(rook)

func _on_black_queen_promoted_button_pressed():
	var queen = Queen.new(promoteAPawnIdx)
	SelectPromotedPiece(queen)

func _on_black_bishop_promoted_button_pressed():
	var bishop = Bishop.new(promoteAPawnIdx)
	SelectPromotedPiece(bishop)

func _on_black_knight_promoted_button_pressed():
	var knight = Knight.new(promoteAPawnIdx)
	SelectPromotedPiece(knight)

func _on_black_rook_promoted_button_pressed():
	var rook = Rook.new(promoteAPawnIdx)
	SelectPromotedPiece(rook)
