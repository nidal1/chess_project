class_name ChessBoard extends Node3D

@export var gameUI: GameUI
@export var gameRules: GameRule

var selectedSquare: ChessSquare = null
var selectedPiece: ChessPiece = null
var removedPiece: ChessPiece = null

func HandleSquareSelection(chessSquare: ChessSquare) -> void:
	if not gameUI.visibleHighlightArrows.has(chessSquare):
		gameUI.ClearHighlightArrows()
		gameUI.ClearHighlightCircles(selectedSquare)
		# SelectNewSquare(chessSquare)
	else:
		# if TakePlaceOfOpponentPiece(chessSquare):
		# playersRoleObserver.emit(SwitchPlayers())
		if removedPiece and removedPiece.isBlackPiece:
			gameUI.UpdateBlackScore(removedPiece.pieceCost)
		else:
			gameUI.UpdateWhiteScore(removedPiece.pieceCost)

		removedPiece = null
		gameUI.ClearHighlightArrows()
		gameUI.ClearHighlightCircles(selectedSquare)
