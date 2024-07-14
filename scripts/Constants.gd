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
		"SelectKingSquareState": "SelectKingSquareState",
		"SelectThePawnSquareState": "SelectThePawnSquareState"
	},
	"RULES": {
		"PromoteAPawnState": "PromoteAPawnState",
		"SwitchTheKingAndRookState": "SwitchTheKingAndRookState",
		"EnPassantState": "EnPassantState",
		"KingUnderAttackState": "KingUnderAttackState",
	}
	
}

const blackPlayerLabel = "Black Player"
const whitePlayerLabel = "White Player"

const COLS = 8
const ROWS = 8

var GRID: Array[ChessSquare] = []

signal observingClickingOnSquares(chessSquare)

var whitePlayer = Player.new()
var blackPlayer = Player.new()

var selectedSquare: ChessSquare = null

var nextSquares: Array = []
var targetSquares: Array[ChessSquare] = []

var targetPositions: Array = []

var isTheKingUnderAttack: bool = false
var castlingData = {
	"leftRook": null,
	"rightRook": null,
	"nextSquares": [],
}

var enPassantData = {
	'leftPawn': null,
	'rightPawn': null,
	'prevPawnSquareIdx': - 1,
	'nextSquare': null,
}

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

func ClearData():
	selectedSquare = null
	targetSquares = []
	nextSquares = []
	castlingData = {
		"leftRook": null,
		"rightRook": null,
		"nextSquares": [],
	}
	enPassantData = {
		'leftPawn': null,
		'rightPawn': null,
		'prevPawnSquareIdx': - 1,
		'nextSquare': null,
	}

func CreateTimer(timer: float=1.0):
	await get_tree().create_timer(timer).timeout

func GetTheBoundariesOfASelectedRow(row: int) -> Array[int]:
	var firstIdx = (row - 1) * Constants.ROWS
	var lastIdx = (row * Constants.ROWS) - 1
	return [firstIdx, lastIdx]
