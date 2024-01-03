extends Node

class_name ChessSquare

var squareType: String
var isEmpty: bool = true
var pieceType: ChessPiece = null
var visualSquare: Node3D = null
var chessBoardObserver: Signal

func AssingVisualSquare(square: Node3D):
	self.visualSquare = square
	var clickableArea: CollisionObject3D =  self.visualSquare.get_child(0)
	clickableArea.connect("input_event", onSquareClicked)

func onSquareClicked(camera:Node, event:InputEvent, position:Vector3, normal:Vector3, shape_idx:int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			chessBoardObserver.emit(self)

func AsignPiece(chessPiece: ChessPiece):
	self.pieceType = chessPiece
	self.isEmpty = false


func DetachPiece():
	self.pieceType = null
	self.isEmpty = true 




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
