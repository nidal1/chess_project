extends Node3D
class_name ChessBoard

const COLS = 8
const ROWS = 8

#Array of ChessSquare.gd
var GRID : Array[ChessSquare]
var currentSquareType : String
var prevSquareType : String

var selectedSquare: ChessSquare = null
var visibleHighlightCircles: Array[Sprite3D] = []



signal observingClickingOnSquares(chessSquare)

var visualChessBoard: Node3D = null

var visualBlackChessSquare = preload("res://sceens/SquareBlack.tscn")
var visualWhiteChessSquare = preload("res://sceens/SquareWhite.tscn")

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
var blackKnight_1 = Knight.new(visualBlackKnight,6)
var blackKnight_2 = Knight.new(visualBlackKnight,1)
var blackBishop_1 = Bishop.new(visualBlackBishop,2)
var blackBishop_2 = Bishop.new(visualBlackBishop,5)
var blackRook_1 = Rook.new(visualBlackRook, 0)
var blackRook_2 = Rook.new(visualBlackRook, 7)
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
var whiteKnight_1 = Knight.new(visualWhiteKnight, 57, false)
var whiteKnight_2 = Knight.new(visualWhiteKnight, 62, false)
var whiteBishop_1 = Bishop.new(visualWhiteBishop, 61, false)
var whiteBishop_2 = Bishop.new(visualWhiteBishop,58, false)
var whiteRook_1 = Rook.new(visualWhiteRook, 63, false)
var whiteRook_2 = Rook.new(visualWhiteRook, 56, false)
var whiteP0 = Pawn.new(visualWhitePawn, 48, false)
var whiteP1 = Pawn.new(visualWhitePawn, 49, false)
var whiteP2 = Pawn.new(visualWhitePawn, 50, false)
var whiteP3 = Pawn.new(visualWhitePawn, 51, false)
var whiteP4 = Pawn.new(visualWhitePawn, 52, false)
var whiteP5 = Pawn.new(visualWhitePawn, 53, false)
var whiteP6 = Pawn.new(visualWhitePawn, 54, false)
var whiteP7 = Pawn.new(visualWhitePawn, 55, false)

func InitTheBoard(_visualChessBoard: Node3D):
	self.OnObservingTheClickingOnSquares()
	self.SetVisualChessBoard(_visualChessBoard)
	self.InitBoardSquares()
	self.InitPieces()
	self.RenderChessSquares()

func SetVisualChessBoard(_visualChessBoard: Node3D):
	self.visualChessBoard = _visualChessBoard

func InitBoardSquares() -> void:
	prevSquareType = "white"
	currentSquareType = "white"
	var squareVisualInstance: Node3D
	for row in range(ROWS):
		for col in range(COLS):
			var square = ChessSquare.new()
			square.squareType = currentSquareType
			square.chessBoardObserver = observingClickingOnSquares
			if square.squareType == "black":
				squareVisualInstance = visualBlackChessSquare.instantiate()
			else:
				squareVisualInstance = visualWhiteChessSquare.instantiate()
			square.AssignVisualSquare(squareVisualInstance)
			GRID.append(square)
			
			if col != COLS - 1:
				SwipeTheColorOfCurrentSquare()
		SwipeTheColorOfTheFistSquareInTheRow()

func RenderChessSquares() -> void:
	var idx = 0
	for row in ROWS:
		for col in COLS:
			var square: ChessSquare = GRID[idx]
			var instance: Node3D = square.visualSquare
			instance.position.x += col
			instance.position.z += row
			visualChessBoard.add_child(instance)
			square.AssignVisualSquare(instance)
			idx += 1

func SwipeTheColorOfCurrentSquare() -> void:
	if prevSquareType == "black":
		currentSquareType = "white"
	else:
		currentSquareType = "black"
	prevSquareType = currentSquareType

func SwipeTheColorOfTheFistSquareInTheRow() -> void:
	currentSquareType = prevSquareType

func InitPieces() -> void:
	var pieces = [
	blackKing,
	blackQueen,
	blackKnight_1,
	blackKnight_2,
	blackBishop_1,
	blackBishop_2,
	blackRook_1,
	blackRook_2,
	blackP0,
	blackP1,
	blackP2,
	blackP3,
	blackP4,
	blackP5,
	blackP6,
	blackP7,
	whiteKing,
	whiteQueen,
	whiteKnight_1,
	whiteKnight_2,
	whiteBishop_1,
	whiteBishop_2,
	whiteRook_1,
	whiteRook_2,
	whiteP0,
	whiteP1,
	whiteP2,
	whiteP3,
	whiteP4,
	whiteP5,
	whiteP6,
	whiteP7,
	]
	if self.GRID.size() > 0:
		for i in range(pieces.size()):
			GRID[pieces[i].pieceIdx].AssignPiece(pieces[i])

func RenderPieces() -> void:
	var idx = 0
	for square in GRID:
		if square.isEmpty == false:
			var visualPieceInstance:Node3D = square.pieceType.visual
			visualPieceInstance.position.y += 0.5
			if square.visualSquare != null and idx == square.pieceType.pieceIdx:
				square.visualSquare.add_child(visualPieceInstance)
		idx += 1
#			await get_tree().create_timer(1.0).timeout

func OnObservingTheClickingOnSquares() -> void:
	observingClickingOnSquares.connect(OnDrawTheLastPositions)

func OnDrawTheLastPositions(chessSquare: ChessSquare) -> void:
	# localize the current position by determinant the row of the current selected piece
	var piece: ChessPiece = chessSquare.pieceType
	if piece:
		ToggleShowHighlightCircles(false)
		ClearHighlightCircles()
		selectedSquare = chessSquare
		if piece.withSpecialMovement:
			HandleSpecialPiece(piece)
		else:
			HandleNonSpecialPiece(piece)
	else:
		if selectedSquare:
			var circle = chessSquare.visualSquare.get_node("Circle")
			if visibleHighlightCircles.has(circle):
				var selectedPiece = selectedSquare.pieceType
				selectedSquare.DetachPiece()
				chessSquare.AssignPiece(selectedPiece)
				ToggleShowHighlightCircles(false)
				ClearHighlightCircles()

func LocalizationOfSelectedPiece(_pieceIdx) -> float:
	return (_pieceIdx / ROWS) + 1

func FixTheBoundariesOfASelectedRow(_row: int) ->Array[int]:
	var firstIdx = (_row - 1) * ROWS
	var lastIdx = (_row * ROWS) - 1
	return [firstIdx, lastIdx]

func ToggleShowHighlightCircles(_visible) -> void:
	if visibleHighlightCircles.size() > 0:
		for arrow in visibleHighlightCircles:
			var arr: Sprite3D = arrow
			arr.visible = _visible

func ClearHighlightCircles() -> void:
	visibleHighlightCircles.clear()
	selectedSquare = null

func HandleSpecialPiece(piece: ChessPiece) -> void:
	var pieceIdx = piece.pieceIdx
	if pieceIdx:
		var selectedRow = LocalizationOfSelectedPiece(pieceIdx)
		
		# calculate the incoming positions
		var coordinations = piece.GetTheNextPosition()
		if coordinations.size():
			for cord in coordinations:
				# determine if the current position is within the boundaries of the current column.
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

func HandleNonSpecialPiece(piece: ChessPiece) -> void:
	var pieceIdx = piece.pieceIdx
	if pieceIdx != null:
		var selectedRow = LocalizationOfSelectedPiece(pieceIdx)
		# calculate the incoming positions
		var blockedDirections: Array[int] = []
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
