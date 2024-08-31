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
		"CheckmateState": "CheckmateState",
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

var mainPlayer: Player = null:
	get:
		return mainPlayer
	set(value):
		mainPlayer = value

var selectedSquare: ChessSquare = null

var nextSquares: Array = []
var targetSquares: Array[ChessSquare] = []

var targetPositions: Array = []

var theKingUnderAttackData = {
	isTheKingUnderAttack = false,
	targetSquares = [],
	nextSquares = [],
	withSpecialMovementPieceTargetPositionsToTheKing = []
}

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

var checkmateData = {
	checkmateChecked = false,
	king = null,
	nextPositions = [],
	targetPositions = [],
}

func SwitchPlayers():

	var temp = Player.CurrentPlayer
	Player.CurrentPlayer = Player.NextPlayer
	Player.NextPlayer = temp

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

func CreateTimer(timer: float = 1.0):
	await get_tree().create_timer(timer).timeout

func GetTheBoundariesOfASelectedRow(row: int) -> Array[int]:
	var firstIdx = (row - 1) * Constants.ROWS
	var lastIdx = (row * Constants.ROWS) - 1
	return [firstIdx, lastIdx]

func CheckIfTheKingIsUnderAttack(gameUI: GameUI) -> bool:
	var king: King = Player.CurrentPlayer.playerPieces.filter(GetTheKing)[0]
	theKingUnderAttackData.isTheKingUnderAttack = king.IsTheKingUnderAttack()
	
	if theKingUnderAttackData.isTheKingUnderAttack:
		var nextPositions = king.GetNextPositions().nextPositions
		nextPositions = king.FilterPositionByOtherPiecesPositions(nextPositions)
		var _nextSquares = FilterSimilarPieces(nextPositions, king)
		theKingUnderAttackData.nextSquares = _nextSquares
		nextPositions = GetThePositionsFromASquaresIndexes(_nextSquares)
		theKingUnderAttackData.targetSquares = GetAllOppositePieces(_nextSquares, king)
		
		gameUI.visibleHighlightRedCircles = GRID[king.pieceIdx]
		gameUI.ToggleShowHighlightRedCircles(true)

		checkmateData = {
			checkmateChecked = false,
			king = king,
			nextPositions = nextPositions,
			targetPositions = GetThePositionsFromASquaresIndexes(theKingUnderAttackData.targetSquares),
		}
		return true
	
	return false


func GetTheKing(p: ChessPiece):
	return p if p is King else null

## Get all possible positions for this current piece after been filtered by blocked directions
func FilterBlockedDirections(nextPositions, chessPiece) -> Array[ChessSquare]:
	var blockedDirections = []
	var _nextSquares: Array[ChessSquare] = []
	for pos in nextPositions:
		var nextSquare = Constants.GRID[pos.nextCol]
		if not nextSquare.isEmpty:
			if nextSquare.pieceType.CanMove(chessPiece) and not blockedDirections.has(pos.direction):
				_nextSquares.append(nextSquare)
			blockedDirections.append(pos.direction)

		else:
			if not blockedDirections.has(pos.direction):
				_nextSquares.append(nextSquare)

	return _nextSquares

func FilterBlockedDirectionsAndReturnPositions(nextPositions, chessPiece) -> Array:
	var blockedDirections = []
	var _nextPositions: Array = []
	for pos in nextPositions:
		var nextSquare = Constants.GRID[pos.nextCol]
		if not nextSquare.isEmpty:
			if nextSquare.pieceType.CanMove(chessPiece) and not blockedDirections.has(pos.direction):
				_nextPositions.append(pos)
			blockedDirections.append(pos.direction)

		else:
			if not blockedDirections.has(pos.direction):
				_nextPositions.append(pos)

	return _nextPositions

func GetThePositionsFromASquaresIndexes(squares: Array[ChessSquare]):
	
	var lf = func(square: ChessSquare):
		var positionData = {
			"nextCol": square.squareIdx,
			"direction": null
		}
		return positionData

	var nextPositions = squares.map(lf)
	return nextPositions

## Get all possible positions for this current piece after been filtered by similar pieces
func FilterSimilarPieces(nextPositions, chessPiece) -> Array[ChessSquare]:
	var _nextSquares: Array[ChessSquare] = []
	for pos in nextPositions:
		var nextSquare = Constants.GRID[pos.nextCol]
		# FIXME: fix this
		if not nextSquare.isEmpty:
			if (chessPiece is Pawn):
					break
			if nextSquare.pieceType.CanMove(chessPiece):
				_nextSquares.append(nextSquare)

		if nextSquare.isEmpty:
			_nextSquares.append(nextSquare)
	
	return _nextSquares

func FilterPiecesForPawnToAttack(nextPositions, chessPiece):
	var _nextSquares: Array[ChessSquare] = []
	for pos in nextPositions:
		var nextSquare = Constants.GRID[pos.nextCol]
		if nextSquare.isEmpty:
			continue
		elif nextSquare.pieceType.CanMove(chessPiece):
			_nextSquares.append(nextSquare)

	return _nextSquares

func GetAllOppositePieces(_nextSquares, piece) -> Array[ChessSquare]:
	var _targetSquares: Array[ChessSquare] = []
	for square in _nextSquares:
		if not square.isEmpty:
			if not AreThePiecesTheSameColor(piece, square.pieceType):
				_targetSquares.append(square)

	return _targetSquares

func AreThePiecesTheSameColor(p1: ChessPiece, p2: ChessPiece) -> bool:
	return int(p1.isBlackPiece) + int(p2.isBlackPiece) == 2


func HandleMovePiece(nextSquare: ChessSquare, _selectedSquare: ChessSquare) -> void:
	var selectedPiece = _selectedSquare.pieceType
	selectedPiece.pieceIdx = nextSquare.squareIdx
	_selectedSquare.DetachPiece()
	nextSquare.AssignPiece(selectedPiece)
	if selectedPiece is Pawn:
		selectedPiece.isTheFirstMove = false

func TakeEnPassantPlace(currentSquare: ChessSquare, enPassantSquare: ChessSquare, opponentSquare: ChessSquare, pawn: Pawn):

	currentSquare.DetachPiece()

	enPassantSquare.AssignPiece(pawn)

	Player.NextPlayer.RemovePiece(opponentSquare.GetPiece())

	opponentSquare.DetachPiece()

	Player.CurrentPlayer.playerPreviousPiece = pawn

func TakePlaceOfOpponentPiece(_nextSquare: ChessSquare, _selectedSquare: ChessSquare) -> ChessPiece:

	var selectedPiece = _selectedSquare.GetPiece()
	var removedPiece = _nextSquare.GetPiece()
	_selectedSquare.DetachPiece()
	_nextSquare.DetachPiece()
	_nextSquare.AssignPiece(selectedPiece)
	selectedPiece.pieceIdx = _nextSquare.squareIdx
	selectedPiece.isMoved = true
	return removedPiece