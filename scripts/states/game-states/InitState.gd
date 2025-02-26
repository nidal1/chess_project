extends StateBase

@export var visualChessBoard: Node3D
@export var visualSpringArm: SpringArm3D


var currentSquareType: String
var prevSquareType: String

var visualBlackChessSquare = preload("res://scenes/SquareBlack.tscn")
var visualWhiteChessSquare = preload("res://scenes/SquareWhite.tscn")

var blackKing = King.new(3)
var blackQueen = Queen.new(4)
var blackKnight_1 = Knight.new(1)
var blackKnight_2 = Knight.new(6)
var blackBishop_1 = Bishop.new(2)
var blackBishop_2 = Bishop.new(5)
var blackRook_1 = Rook.new(0)
var blackRook_2 = Rook.new(7)
var blackP0 = Pawn.new(8)
var blackP1 = Pawn.new(9)
var blackP2 = Pawn.new(10)
var blackP3 = Pawn.new(11)
var blackP4 = Pawn.new(12)
var blackP5 = Pawn.new(13)
var blackP6 = Pawn.new(14)
var blackP7 = Pawn.new(15)

var whiteKing = King.new(59, false)
var whiteQueen = Queen.new(24, false)
var whiteKnight_1 = Knight.new(57, false)
var whiteKnight_2 = Knight.new(62, false)
var whiteBishop_1 = Bishop.new(61, false)
var whiteBishop_2 = Bishop.new(37, false)
var whiteRook_1 = Rook.new(63, false)
var whiteRook_2 = Rook.new(56, false)
var whiteP0 = Pawn.new(48, false)
var whiteP1 = Pawn.new(49, false)
var whiteP2 = Pawn.new(50, false)
var whiteP3 = Pawn.new(51, false)
var whiteP4 = Pawn.new(52, false)
var whiteP5 = Pawn.new(53, false)
var whiteP6 = Pawn.new(54, false)
var whiteP7 = Pawn.new(55, false)

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

func enter(data = null):
	self.InitPlayers()
	self.InitBoardSquares()
	self.InitPieces()
	self.RenderChessSquares()
	self.RotateTheBoard()

	stateMachine.switchTo(Constants.STATES.GAME.WaitingState)

func InitBoardSquares() -> void:
	prevSquareType = "white"
	currentSquareType = "white"
	var squareVisualInstance: Node3D
	var idx = 0
	for row in range(Constants.ROWS):
		for col in range(Constants.COLS):
			var square = ChessSquare.new()
			square.squareType = currentSquareType
			square.squareIdx = idx
			square.chessBoardObserver = Constants.observingClickingOnSquares
			if square.squareType == "black":
				squareVisualInstance = visualBlackChessSquare.instantiate()
			else:
				squareVisualInstance = visualWhiteChessSquare.instantiate()
			square.AssignVisualSquare(squareVisualInstance)
			Constants.GRID.append(square)
			idx += 1
			if col != Constants.COLS - 1:
				SwipeTheColorOfCurrentSquare()
		SwipeTheColorOfTheFistSquareInTheRow()

func InitPieces() -> void:
	if Constants.GRID.size() > 0:
		for i in range(pieces.size()):
			Constants.GRID[pieces[i].pieceIdx].AssignPiece(pieces[i])

func RenderChessSquares() -> void:
	var idx = 0
	for row in Constants.ROWS:
		for col in Constants.COLS:
			var square: ChessSquare = Constants.GRID[idx]
			var instance: Node3D = square.visualSquare
			instance.position.x += col
			instance.position.z += row
			visualChessBoard.add_child(instance)
			square.AssignVisualSquare(instance)
			square.SetVisualIdxLabel(idx)
			idx += 1

func InitPlayers():
	var score
	Constants.blackPlayer.playerLabel = Constants.blackPlayerLabel
	Constants.blackPlayer.playerPieces = pieces.slice(0, pieces.size() / 2)
	
	score = Constants.blackPlayer.GetTotalPiecesCost()
	Constants.blackPlayer.playerScoreObserver.emit(score)

	Constants.whitePlayer.playerLabel = Constants.whitePlayerLabel
	Constants.whitePlayer.playerPieces = pieces.slice(pieces.size() / 2, pieces.size())
	score = Constants.whitePlayer.GetTotalPiecesCost()
	Constants.whitePlayer.playerScoreObserver.emit(score)


	Constants.mainPlayer = Constants.whitePlayer if Constants.whitePlayer.isMainSession else Constants.blackPlayer

	Player.CurrentPlayer = Constants.mainPlayer if Constants.mainPlayer.playerLabel == Constants.whitePlayerLabel else Constants.whitePlayer
	Player.NextPlayer = Constants.mainPlayer if Constants.mainPlayer.playerLabel == Constants.blackPlayerLabel else Constants.blackPlayer


	stateMachine.gameUI.InitScoreLabels(Constants.blackPlayer.playerScore, Constants.whitePlayer.playerScore)
	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

func RotateTheBoard():
	if Constants.mainPlayer.playerLabel == "White Player":
		visualSpringArm.rotate_y(PI)

func SwipeTheColorOfCurrentSquare() -> void:
	if prevSquareType == "black":
		currentSquareType = "white"
	else:
		currentSquareType = "black"
	prevSquareType = currentSquareType

func SwipeTheColorOfTheFistSquareInTheRow() -> void:
	currentSquareType = prevSquareType
