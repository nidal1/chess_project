class_name GameRule extends Node3D

@export var gameUI: GameUI

const COLS = 8
const ROWS = 8

func OnCheckRule(checkSquare: ChessSquare):
	print("check: ", checkSquare)

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
