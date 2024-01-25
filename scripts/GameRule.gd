class_name GameRule extends Node3D

@export var gameUI: GameUI

var promoteAPawnIdx: int
var selectedSquare: ChessSquare = null

signal promoteAPawn(selectedPiece)

func PromoteAPawn(pawn: Pawn, square: ChessSquare) -> void:
	if pawn.isBlackPiece:
		gameUI.ToggleBlackHPassantContainer()
	else:
		gameUI.ToggleWhiteHPassantContainer()
	promoteAPawnIdx = pawn.pieceIdx
	square.DetachPiece()
	selectedSquare = square
	promoteAPawn.connect(OnSelectingPromotedPiece)

func OnSelectingPromotedPiece(promotedPiece: ChessPiece):
	selectedSquare.AssignPiece(promotedPiece)

func SelectPromotedPiece(promotedPiece: ChessPiece):
	promoteAPawn.emit(promotedPiece)
	if promotedPiece.isBlackPiece:
		gameUI.ToggleBlackHPassantContainer()
	else:
		gameUI.ToggleWhiteHPassantContainer()


func _on_white_queen_passant_button_pressed():
	var queen = Queen.new(promoteAPawnIdx, false)
	SelectPromotedPiece(queen)


func _on_white_bishop_passant_button_pressed():
	var bishop = Bishop.new(promoteAPawnIdx, false)
	SelectPromotedPiece(bishop)


func _on_white_knight_passant_button_pressed():
	var knight = Knight.new(promoteAPawnIdx, false)
	SelectPromotedPiece(knight)


func _on_white_rook_passant_button_pressed():
	var rook = Rook.new(promoteAPawnIdx, false)
	SelectPromotedPiece(rook)


func _on_black_queen_passant_button_pressed():
	var queen = Queen.new(promoteAPawnIdx)
	SelectPromotedPiece(queen)


func _on_black_bishop_passant_button_pressed():
	var bishop = Bishop.new(promoteAPawnIdx)
	SelectPromotedPiece(bishop)


func _on_black_knight_passant_button_pressed():
	var knight = Knight.new(promoteAPawnIdx)
	SelectPromotedPiece(knight)


func _on_black_rook_passant_button_pressed():
	var rook = Rook.new(promoteAPawnIdx)
	SelectPromotedPiece(rook)
