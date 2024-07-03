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

enum GameStates {
	INITIAL_STATE,
	CHECK_STATE,
	CHECKMATE_STATE,
	STALEMATE_STATE,
	CASTLING_STATE,
	EN_PASSANT_STATE,
	PAWN_PROMOTION_STATE,
	DRAW_STATE,
	SQUARE_SELECTION_STATE,
	SWITCH_PLAYER_ROLE_STATE,
	ENEMY_SQUARE_SELECTION_STATE,
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

func SwitchPlayers():
	if Player.CurrentPlayer == blackPlayer:
		Player.CurrentPlayer = whitePlayer
		Player.NextPlayer = blackPlayer
		return
	Player.CurrentPlayer = blackPlayer
	Player.NextPlayer = whitePlayer

func CreateTimer(timer: float=1.0):
	await get_tree().create_timer(timer).timeout