extends Node3D
class_name ChessBoard

const COLS = 8
const ROWS = 8

#Array of ChessSquare.gd
var GRID = Array()

var currentSquareType : String
var prevSquareType : String

#Array of visual chess squares instanciated in the scene
var visualChessSquares = Array()

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
var blackKnight_1 = WhiteKnight.new(visualBlackKnight,1)
var blackKnight_2 = BlackKnight.new(visualBlackKnight,6)
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

var whiteKing = King.new(visualWhiteKing, 59)
var whiteQueen = Queen.new(visualWhiteQueen, 60)
var whiteKnight_1 = WhiteKnight.new(visualWhiteKnight, 57)
var whiteKnight_2 = BlackKnight.new(visualWhiteKnight, 62)
var whiteBishop_1 = WhiteBishop.new(visualWhiteBishop, 61)
var whiteBishop_2 = BlackBishop.new(visualWhiteBishop,58)
var whiteRook_1 = WhiteRook.new(visualWhiteRook, 63)
var whiteRook_2 = BlackRook.new(visualWhiteRook, 56)
var whiteP0 = Pawn.new(visualWhitePawn, 48)
var whiteP1 = Pawn.new(visualWhitePawn, 49)
var whiteP2 = Pawn.new(visualWhitePawn, 50)
var whiteP3 = Pawn.new(visualWhitePawn, 51)
var whiteP4 = Pawn.new(visualWhitePawn, 52)
var whiteP5 = Pawn.new(visualWhitePawn, 53)
var whiteP6 = Pawn.new(visualWhitePawn, 54)
var whiteP7 = Pawn.new(visualWhitePawn, 55)

var visibleDownArrow: Sprite3D = null

signal observingClickingOnSquares(chessSquare)

func InitBoardSquares():
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

func SwapeTheColorOfCurrentSquare():
	if prevSquareType == "black":
		currentSquareType = "white"
	else:
		currentSquareType = "black"
	prevSquareType = currentSquareType

func SwapeTheColorOfTheFistSquareInTheRow():
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

func OnObservingTheClickingOnSquares():
	observingClickingOnSquares.connect(OnDrawThePaths)

func OnDrawThePaths(chessSquare: ChessSquare):
	var selectedPiece = chessSquare.pieceType
	if selectedPiece:
		if visibleDownArrow:
			visibleDownArrow.visible = false
		var currentIdx = selectedPiece.pieceIdx
		var movementAmount = selectedPiece.movementAmount
		var currentSquare: ChessSquare = GRID[currentIdx + movementAmount]
		currentSquare.get_child(0)
		visibleDownArrow = currentSquare.visualSquare.get_node("DownArrow")
		visibleDownArrow.visible = true