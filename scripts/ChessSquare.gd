extends Node

class_name ChessSquare

var squareType: String
var isEmpty: bool = true
var pieceType: ChessPiece = null
var visualSquare: Node3D = null
var chessBoardObserver: Signal

func AssingVisualSquare(square: Node3D) -> void:
	self.visualSquare = square
	var clickableArea: CollisionObject3D =  self.visualSquare.get_child(0)
	clickableArea.connect("input_event", onSquareClicked)

func onSquareClicked(camera:Node, event:InputEvent, position:Vector3, normal:Vector3, shape_idx:int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			chessBoardObserver.emit(self)

func AsignPiece(chessPiece: ChessPiece) -> void:
	self.pieceType = chessPiece
	self.isEmpty = false


func DetachPiece() -> void:
	self.pieceType = null
	self.isEmpty = true 
