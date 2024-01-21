extends Node3D
class_name ChessBoard

const COLS = 8
const ROWS = 8


var GRID : Array[ChessSquare]
var currentSquareType : String
var prevSquareType : String


var selectedSquare: ChessSquare = null
var visibleHighlightCircles: Array[ChessSquare] = []
var visibleHighlightArrows: Array[ChessSquare] = []


signal observingClickingOnSquares(chessSquare)
var whiteScoreObserver: Signal
var blackScoreObserver: Signal
var playersRoleObserver: Signal


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

var players = {
	"blackPieces": {
		"label": "Black Player",
		"pieces": pieces.slice(0, pieces.size()/2)
	},
	"whitePieces": {
		"label":"White Player",
		"pieces":pieces.slice(pieces.size()/2 , pieces.size())
	}
}

var currentPlayer = players.blackPieces.label


func InitTheBoard(_visualChessBoard: Node3D, _whiteScoreObserver: Signal, _blackScoreObserver: Signal, _playersRoleObserver: Signal ):
	self.OnObservingTheClickingOnSquares()
	self.SetVisualChessBoard(_visualChessBoard)
	self.SetScoreObservers(_whiteScoreObserver, _blackScoreObserver)
	self.SetPlayersRole(_playersRoleObserver)
	self.InitBoardSquares()
	self.InitPieces()
	self.RenderChessSquares()

func SetScoreObservers(_whiteScoreObserver: Signal, _blackScoreObserver: Signal):
	self.blackScoreObserver = _blackScoreObserver
	self.whiteScoreObserver = _whiteScoreObserver

func SetPlayersRole(_playersRoleObserver: Signal):
	playersRoleObserver = _playersRoleObserver

func SetVisualChessBoard(_visualChessBoard: Node3D):
	self.visualChessBoard = _visualChessBoard

func InitBoardSquares() -> void:
	prevSquareType = "white"
	currentSquareType = "white"
	var squareVisualInstance: Node3D
	var idx = 0
	for row in range(ROWS):
		for col in range(COLS):
			var square = ChessSquare.new()
			square.squareType = currentSquareType
			square.squareIdx = idx
			square.chessBoardObserver = observingClickingOnSquares
			if square.squareType == "black":
				squareVisualInstance = visualBlackChessSquare.instantiate()
			else:
				squareVisualInstance = visualWhiteChessSquare.instantiate()
			square.AssignVisualSquare(squareVisualInstance)
			GRID.append(square)
			idx += 1
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

func InitBlackPiecesScore() -> int :
	var blackPiecesScore = 0
	for piece in players.blackPieces.pieces:
		var p: ChessPiece = piece
		blackPiecesScore += p.pieceCost
	return blackPiecesScore

func InitWhitePiecesScore() -> int :
	var whitePiecesScore = 0
	for piece in players.whitePieces.pieces:
		var p: ChessPiece = piece
		whitePiecesScore += p.pieceCost
	return whitePiecesScore

func InitPlayerRole() -> String:
	return currentPlayer

func OnObservingTheClickingOnSquares() -> void:
	observingClickingOnSquares.connect(OnDrawTheLastPositions)

func OnDrawTheLastPositions(chessSquare: ChessSquare) -> void:
	if not selectedSquare or chessSquare.pieceType:
		HandleSquareSelection(chessSquare)
	else:
		if HandleMovePiece(chessSquare):
			playersRoleObserver.emit(SwitchPlayers())
		ClearHighlightCircles()
		ClearHighlightArrows()

func HandleSquareSelection(chessSquare: ChessSquare) -> void:
	if not visibleHighlightArrows.has(chessSquare):
		SelectNewSquare(chessSquare)
	else:
		TakePlaceOfOpponentPiece(chessSquare)
		playersRoleObserver.emit(SwitchPlayers())

func SelectNewSquare(chessSquare: ChessSquare) -> void:
	ClearHighlightCircles()
	if chessSquare.pieceType:
		var piece: ChessPiece = chessSquare.pieceType
		if piece and CheckRole(piece):
			ClearHighlightArrows()
			selectedSquare = chessSquare
			if piece.withSpecialMovement:
				HandleSpecialPiece(piece)
			else:
				HandleNonSpecialPiece(piece)
			GetAllOppositePieces()

func TakePlaceOfOpponentPiece(chessSquare: ChessSquare) -> void:
	ClearHighlightArrows()
	var selectedPiece = selectedSquare.GetPiece()
	var removedPiece = chessSquare.GetPiece()
	selectedSquare.DetachPiece()
	chessSquare.DetachPiece()
	chessSquare.AssignPiece(selectedPiece)
	selectedPiece.pieceIdx = chessSquare.squareIdx
	ClearHighlightCircles()
	if removedPiece.isBlackPiece:
		blackScoreObserver.emit(removedPiece.pieceCost)
	else:
		whiteScoreObserver.emit(removedPiece.pieceCost)

func HandleMovePiece(chessSquare: ChessSquare) -> bool:
	var moved = false
	if visibleHighlightCircles.has(chessSquare):
		var selectedPiece = selectedSquare.pieceType
		selectedPiece.pieceIdx = chessSquare.squareIdx
		selectedSquare.DetachPiece()
		chessSquare.AssignPiece(selectedPiece)
		if selectedPiece is Pawn:
				selectedPiece.isTheFirstMove = false
		moved = true
	return moved

func LocalizationOfSelectedPiece(_pieceIdx) -> float:
	return (_pieceIdx / ROWS) + 1

func FixTheBoundariesOfASelectedRow(_row: int) ->Array[int]:
	var firstIdx = (_row - 1) * ROWS
	var lastIdx = (_row * ROWS) - 1
	return [firstIdx, lastIdx]

func ToggleShowHighlightCircles(_visible) -> void:
	if visibleHighlightCircles.size() > 0:
		for square in visibleHighlightCircles:
			square.ToggleVisualCircleVisibility(_visible)

func ToggleShowHighlightArrows(_visible) -> void:
	if visibleHighlightArrows.size() > 0:
		for square in visibleHighlightArrows:
			square.ToggleVisualDownArrowVisibility(_visible)

func ClearHighlightCircles() -> void:
	ToggleShowHighlightCircles(false)
	visibleHighlightCircles.clear()
	selectedSquare = null

func ClearHighlightArrows() -> void:
	ToggleShowHighlightArrows(false)
	visibleHighlightArrows.clear()

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
							if nextSquare.pieceType:
								if piece.CanMove(nextSquare.pieceType) and not piece is Pawn:
									visibleHighlightCircles.append(nextSquare)
							else:
								visibleHighlightCircles.append(nextSquare)
							
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
								visibleHighlightCircles.append(nextSquare)
								blockedDirections.append(coor.direction)
							else:
								blockedDirections.append(coor.direction)
						else:
							visibleHighlightCircles.append(nextSquare)
			ToggleShowHighlightCircles(true)
		else:
			ToggleShowHighlightCircles(false)

func GetAllOppositePieces() -> void:
	if selectedSquare :
		var selectedPiece: ChessPiece = selectedSquare.pieceType
		if selectedPiece is Pawn:
			var oppositePositions = selectedPiece.GetAllOppositePiecePositions()
			var selectedRow = LocalizationOfSelectedPiece(selectedPiece.pieceIdx)
			var nextSelectedRow = selectedRow + oppositePositions.row 
			var boundaries = FixTheBoundariesOfASelectedRow(nextSelectedRow)
			var selectedCol = oppositePositions.col
			var firstIdx = boundaries[0]
			var lastIdx = boundaries[1]
			for col in selectedCol:
				if col >= firstIdx and col <= lastIdx:
					var nextSquare: ChessSquare = GRID[col]
					if not nextSquare.isEmpty and not AreThePiecesTheSameColor(nextSquare.pieceType, selectedPiece):
						visibleHighlightArrows.append(nextSquare)
			ToggleShowHighlightArrows(true)
		else:
			if visibleHighlightCircles.size():
				for nextSquare in visibleHighlightCircles:
					if not nextSquare.isEmpty and not AreThePiecesTheSameColor(nextSquare.pieceType, selectedPiece):
						visibleHighlightArrows.append(nextSquare)
			ToggleShowHighlightArrows(true)

func AreThePiecesTheSameColor(p1: ChessPiece, p2: ChessPiece) -> bool:
	return int(p1.isBlackPiece) + int(p2.isBlackPiece) != 1

func SwitchPlayers() -> String:
	if currentPlayer == players.blackPieces.label:
		currentPlayer = players.whitePieces.label
	else: currentPlayer = players.blackPieces.label
	return currentPlayer

func CheckRole(_chessPiece: ChessPiece) -> bool:
	if currentPlayer == players.blackPieces.label and _chessPiece.isBlackPiece:
		return true
	if currentPlayer == players.whitePieces.label and not _chessPiece.isBlackPiece:
		return true
	return false
