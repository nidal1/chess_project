extends Node3D
class_name ChessBoard

const COLS = 8
const ROWS = 8

#Array of ChessSquare.gd
var GRID : Array[ChessSquare]
var currentSquareType : String
var prevSquareType : String

var visibleHighlightCircles: Array[Sprite3D]

signal observingClickingOnSquares(chessSquare)

var visualBlackKing = preload("res://sceens/black_king.tscn")
var visualBlackQueen = preload("res://sceens/black_queen.tscn")
var visualBlackBishop = preload("res://sceens/black_bishop.tscn")
var visualBlackKnight = preload("res://sceens/black_knight.tscn")
var visualBlackRook = preload("res://sceens/black_rook.tscn")
var visualBlackPawn = preload("res://sceens/black_pawn.tscn")

var visualWhiteKing = preload("res://sceens/white_king.tscn")
var visualWhiteQueen = preload("res://sceens/white_queen.tscn")
var visualWhiteBishop = preload("res://sceens/white_bishop.tscn")
var visualWhiteKnight = preload("res://sceens/white_knight.tscn")
var visualWhiteRook = preload("res://sceens/white_rook.tscn")
var visualWhitePawn = preload("res://sceens/white_pawn.tscn")

var blackKing = King.new(visualBlackKing, 3)
var blackQueen = Queen.new(visualBlackQueen, 4)
var blackKnight_1 = WhiteKnight.new(visualBlackKnight,6)
var blackKnight_2 = BlackKnight.new(visualBlackKnight,1)
var blackBishop_1 = WhiteBishop.new(visualBlackBishop,2)
var blackBishop_2 = BlackBishop.new(visualBlackBishop,5)
var blackRook_1 = WhiteRook.new(visualBlackRook, 0)
var blackRook_2 = BlackRook.new(visualBlackRook, 7)
var blackP0 = Pawn.new(visualBlackPawn, 8)
var blackP1 = Pawn.new(visualBlackPawn, 9)
var blackP2 = Pawn.new(visualBlackPawn, 10)
var blackP3 = Pawn.new(visualBlackPawn, 11)
var blackP4 = Pawn.new(visualBlackPawn, 12)
var blackP5 = Pawn.new(visualBlackPawn, 13)
var blackP6 = Pawn.new(visualBlackPawn, 14)
var blackP7 = Pawn.new(visualBlackPawn, 15)

var whiteKing = King.new(visualWhiteKing, 59, false)
var whiteQueen = Queen.new(visualWhiteQueen, 60, false)
var whiteKnight_1 = WhiteKnight.new(visualWhiteKnight, 57, false)
var whiteKnight_2 = BlackKnight.new(visualWhiteKnight, 62, false)
var whiteBishop_1 = WhiteBishop.new(visualWhiteBishop, 61, false)
var whiteBishop_2 = BlackBishop.new(visualWhiteBishop,58, false)
var whiteRook_1 = WhiteRook.new(visualWhiteRook, 63, false)
var whiteRook_2 = BlackRook.new(visualWhiteRook, 56, false)
var whiteP0 = Pawn.new(visualWhitePawn, 48, false)
var whiteP1 = Pawn.new(visualWhitePawn, 49, false)
var whiteP2 = Pawn.new(visualWhitePawn, 50, false)
var whiteP3 = Pawn.new(visualWhitePawn, 51, false)
var whiteP4 = Pawn.new(visualWhitePawn, 52, false)
var whiteP5 = Pawn.new(visualWhitePawn, 53, false)
var whiteP6 = Pawn.new(visualWhitePawn, 54, false)
var whiteP7 = Pawn.new(visualWhitePawn, 55, false)



func InitBoardSquares() -> void:
	prevSquareType = "white"
	currentSquareType = "white"
	for row in range(ROWS):
		for col in range(COLS):
			var square = ChessSquare.new()
			square.chessBoardObserver = observingClickingOnSquares
			GRID.append(square)
			square.squareType = currentSquareType
			if col != COLS - 1:
				SwapeTheColorOfCurrentSquare()
		SwapeTheColorOfTheFistSquareInTheRow()

func SwapeTheColorOfCurrentSquare() -> void:
	if prevSquareType == "black":
		currentSquareType = "white"
	else:
		currentSquareType = "black"
	prevSquareType = currentSquareType

func SwapeTheColorOfTheFistSquareInTheRow() -> void:
	currentSquareType = prevSquareType

func InitPieces():
	if self.GRID.size() > 0:
		GRID[blackKing.pieceIdx].AsignPiece(blackKing)
		GRID[blackQueen.pieceIdx].AsignPiece(blackQueen)
		GRID[blackKnight_1.pieceIdx].AsignPiece(blackKnight_1)
		GRID[blackKnight_2.pieceIdx].AsignPiece(blackKnight_2)
		GRID[blackBishop_1.pieceIdx].AsignPiece(blackBishop_1)
		GRID[blackBishop_2.pieceIdx].AsignPiece(blackBishop_2)
		GRID[blackRook_1.pieceIdx].AsignPiece(blackRook_1)
		GRID[blackRook_2.pieceIdx].AsignPiece(blackRook_2)
		GRID[blackP0.pieceIdx].AsignPiece(blackP0)
		GRID[blackP1.pieceIdx].AsignPiece(blackP1)
		GRID[blackP2.pieceIdx].AsignPiece(blackP2)
		GRID[blackP3.pieceIdx].AsignPiece(blackP3)
		GRID[blackP4.pieceIdx].AsignPiece(blackP4)
		GRID[blackP5.pieceIdx].AsignPiece(blackP5)
		GRID[blackP6.pieceIdx].AsignPiece(blackP6)
		GRID[blackP7.pieceIdx].AsignPiece(blackP7)
		
		GRID[whiteKing.pieceIdx].AsignPiece(whiteKing)
		GRID[whiteQueen.pieceIdx].AsignPiece(whiteQueen)
		GRID[whiteKnight_1.pieceIdx].AsignPiece(whiteKnight_1)
		GRID[whiteKnight_2.pieceIdx].AsignPiece(whiteKnight_2)
		GRID[whiteBishop_1.pieceIdx].AsignPiece(whiteBishop_1)
		GRID[whiteBishop_2.pieceIdx].AsignPiece(whiteBishop_2)
		GRID[whiteRook_1.pieceIdx].AsignPiece(whiteRook_1)
		GRID[whiteRook_2.pieceIdx].AsignPiece(whiteRook_2)
		GRID[whiteP0.pieceIdx].AsignPiece(whiteP0)
		GRID[whiteP1.pieceIdx].AsignPiece(whiteP1)
		GRID[whiteP2.pieceIdx].AsignPiece(whiteP2)
		GRID[whiteP3.pieceIdx].AsignPiece(whiteP3)
		GRID[whiteP4.pieceIdx].AsignPiece(whiteP4)
		GRID[whiteP5.pieceIdx].AsignPiece(whiteP5)
		GRID[whiteP6.pieceIdx].AsignPiece(whiteP6)
		GRID[whiteP7.pieceIdx].AsignPiece(whiteP7)

func OnObservingTheClickingOnSquares() -> void:
	observingClickingOnSquares.connect(OnDrawTheLastPositions)

func OnDrawTheLastPositions(chessSquare: ChessSquare):
	ToggleShowHighlightCircles(false)
	visibleHighlightCircles.clear()
	# localize the current position by determinanting the row of the current selected piece
	var piece: ChessPiece = chessSquare.pieceType
	if piece:
		if piece.withSpicialMovement:
			HandleTheLastPositonsOfASpecialPiece(piece)
		else:
			HandleTheLastPositonsOfANonSpecialPiece(piece)


func LocalizationOfSelectedPiece(_pieceIdx) -> float:
	return (_pieceIdx / ROWS) + 1

func FixTheBoundariesOfASelectedRow(_row: int) ->Array[int]:
	var firstIdx = (_row - 1) * ROWS
	var lastIdx = (_row * ROWS) - 1
	return [firstIdx, lastIdx]


func ToggleShowHighlightCircles(_visible):
	if visibleHighlightCircles.size() > 0:
		for arrow in visibleHighlightCircles:
			var arr: Sprite3D = arrow
			arr.visible = _visible

func HandleTheLastPositonsOfASpecialPiece(piece: ChessPiece):
	var pieceIdx = piece.pieceIdx
	if pieceIdx:
		var selectedRow = LocalizationOfSelectedPiece(pieceIdx)
		
		# calculate the incoming positions
		var cordinations = piece.GetTheNextPosition()
		if cordinations.size():
			for cord in cordinations:
				# determine if the current position is within the boudries of the current column.
				var nextSelectedRow = selectedRow + cord.row 
				if nextSelectedRow > 0 and nextSelectedRow <= ROWS :
					var boundaries = FixTheBoundariesOfASelectedRow(nextSelectedRow)
					# enable or disable the down arrows
					var selectedCol = cord.col
					var firstIdx = boundaries[0]
					var lastIdx = boundaries[1]
					for col in selectedCol:
						if col >= firstIdx and col <= lastIdx:
							var nextSquare: ChessSquare = GRID[col]
							if piece.CanMove(nextSquare.pieceType):
								var circle: Sprite3D = nextSquare.visualSquare.get_node("Circle")
								visibleHighlightCircles.append(circle)
							
			ToggleShowHighlightCircles(true)
		else:
			ToggleShowHighlightCircles(false)


func HandleTheLastPositonsOfANonSpecialPiece(piece: ChessPiece):
	var pieceIdx = piece.pieceIdx
	if pieceIdx != null:
		var selectedRow = LocalizationOfSelectedPiece(pieceIdx)
		# calculate the incoming positions
		var blockedDirections: Array[String] = []
		var coordinations = piece.GetTheNextPosition()
		if coordinations.size():
			for coor in coordinations:
				var nextSelectedRow = selectedRow + coor.row 
				if nextSelectedRow > 0 and nextSelectedRow <= ROWS  and not blockedDirections.has(coor.direction):
					var boundaries = FixTheBoundariesOfASelectedRow(nextSelectedRow)
					# enable or disable the down arrows
					var selectedCol = coor.col
					var firstIdx = boundaries[0]
					var lastIdx = boundaries[1]
					if selectedCol >= firstIdx and selectedCol <= lastIdx:
						var nextSquare: ChessSquare = GRID[selectedCol]
						if nextSquare.pieceType:
							if piece.CanMove(nextSquare.pieceType) :
								var circle: Sprite3D = nextSquare.visualSquare.get_node("Circle")
								visibleHighlightCircles.append(circle)
								blockedDirections.append(coor.direction)
							else:
								blockedDirections.append(coor.direction)
						else:
							var circle: Sprite3D = nextSquare.visualSquare.get_node("Circle")
							visibleHighlightCircles.append(circle)
			ToggleShowHighlightCircles(true)
		else:
			ToggleShowHighlightCircles(false)
		
