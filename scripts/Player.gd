extends Node3D

class_name Player

var playerPieces: Array = []
var playerLabel: String = ""
var playerScore: int = 0
#FIXME: Convert this to an array
var playerPreviousPiece: ChessPiece = null

signal playerScoreObserver(newScore: int, callable)

static var CurrentPlayer: Player = null
static var NextPlayer: Player = null

func _init():
	playerScoreObserver.connect(SetPlayerScore)

func SetPlayerScore(score: int, callable=null) -> void:
	playerScore = score
	if callable != null:
		callable = callable as Callable
		callable.call(playerScore)

func GetTotalPiecesCost() -> int:
	var total = 0
	for p in playerPieces:
		p = p as ChessPiece
		total += p.pieceCost
	return total

func RemovePiece(piece: ChessPiece):
	var pieceIdx = self.playerPieces.find(piece)
	self.playerPieces.remove_at(pieceIdx)

func AppendPiece(piece: ChessPiece):
	self.playerPieces.append(piece)

static func CheckRole(_playerLabel: String) -> bool:
	return _playerLabel == Player.CurrentPlayer.playerLabel
