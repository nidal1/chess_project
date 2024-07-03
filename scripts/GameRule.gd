class_name GameRule extends Node3D

@export var gameUI: GameUI

var gameConstants = preload ("res://scripts/Constants.gd")

const COLS = 8
const ROWS = 8

var promoteAPawnIdx: int
var selectedSquare: ChessSquare = null
var checkState = CheckState.new()

var currentState = gameConstants.GameStates.INITIAL_STATE

signal promoteAPawn(selectedPiece)

var CheckRule: Signal

func _ready():
	CheckRule.connect(OnCheckRule)

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

func OnCheckRule(checkSquare: ChessSquare):
	print("check: ", checkSquare)

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

func VerifyCheck(selectedPiece: ChessPiece, grid: Array[ChessSquare]) -> bool:
	var coordinates = selectedPiece.GetTheNextPosition()
	var selectedRow = LocalizationOfSelectedPiece(selectedPiece.pieceIdx)
	for coor in coordinates:
		var nextSelectedRow = selectedRow + coor.row
		if nextSelectedRow > 0 and nextSelectedRow <= ROWS:
			var boundaries = GetTheBoundariesOfASelectedRow(nextSelectedRow)
			var firstIdx = boundaries[0]
			var lastIdx = boundaries[1]

			var colArray: Array = []
			var selectedCol = coor.col
			if selectedCol is int:
				colArray.append(selectedCol)
			elif selectedCol is Array:
				colArray = selectedCol

			if colArray.size():
				for col in colArray:
					if col >= firstIdx and col <= lastIdx:
						var nextSquare: ChessSquare = grid[col]
						if not nextSquare.isEmpty:
							var piece: ChessPiece = nextSquare.GetPiece()
							if piece is King:
								return true

	return false

func LocalizationOfSelectedPiece(_pieceIdx) -> float:
	return (_pieceIdx / ROWS) + 1

func GetTheBoundariesOfASelectedRow(_row: int) -> Array[int]:
	var firstIdx = (_row - 1) * ROWS
	var lastIdx = (_row * ROWS) - 1
	return [firstIdx, lastIdx]

func IsThePieceReachesTheSides(piece: ChessPiece) -> bool:
	var row
	if piece.isBlackPiece:
		row = ROWS
	else:
		row = 1
	return row == LocalizationOfSelectedPiece(piece.pieceIdx)
