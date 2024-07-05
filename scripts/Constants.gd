extends Node3D

enum Direction {
	TOP,
	LEFT,
	DOWN,
	RIGHT,
	TOP_LEFT,
	TOP_RIGHT,
	DOWN_LEFT,
	DOWN_RIGHT
}

const STATES = {
	"GAME": {
		"InitState": "InitState",
		"SelectSquareState": "SelectSquareState",
		"SwitchPlacesState": "SwitchPlacesState",
		"TakeOppositePlaceState": "TakeOppositePlaceState",
		"WaitingState": "WaitingState",
		"SelectKingSquareState": "SelectKingSquareState"
	},
	"RULES": {
		"PromoteAPawnState": "PromoteAPawnState",
		"SwitchTheKingAndRookState": "SwitchTheQueenAndRook"
	}
	
}

const blackPlayerLabel = "Black Player"
const whitePlayerLabel = "White Player"

var GRID: Array[ChessSquare] = []

signal observingClickingOnSquares(chessSquare)

var whitePlayer = Player.new()
var blackPlayer = Player.new()

var selectedSquare: ChessSquare = null

var nextSquares: Array = []
var targetSquares: Array[ChessSquare] = []

var targetPositions: Array = []
var nextSquaresToSwapTheKingTo: Array[ChessSquare] = []

func SwitchPlayers():
	if Player.CurrentPlayer == blackPlayer:
		Player.CurrentPlayer = whitePlayer
		Player.NextPlayer = blackPlayer
		return
	Player.CurrentPlayer = blackPlayer
	Player.NextPlayer = whitePlayer

func UpdatePlayerScore(UpdateBlackScore: Callable, UpdateWhiteScore: Callable):
	if Player.NextPlayer.playerLabel == blackPlayerLabel:
		var score = Player.NextPlayer.GetTotalPiecesCost()
		Player.NextPlayer.playerScoreObserver.emit(score, UpdateBlackScore)
	else:
		var score = Player.NextPlayer.GetTotalPiecesCost()
		Player.NextPlayer.playerScoreObserver.emit(score, UpdateWhiteScore)

func CreateTimer(timer: float=1.0):
	await get_tree().create_timer(timer).timeout
