class_name ChessSquare

var squareType: String
var squareIdx: int
var isEmpty: bool = true
var pieceType: ChessPiece = null
var visualSquare: Node3D = null
var chessBoardObserver: Signal

func AssignVisualSquare(square: Node3D) -> void:
	self.visualSquare = square
	var clickableArea: CollisionObject3D = self.visualSquare.get_child(0)
	if not clickableArea.is_connected("input_event", onSquareClicked):
		clickableArea.connect("input_event", onSquareClicked)

func onSquareClicked(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			chessBoardObserver.emit(self)

func AssignPiece(chessPiece: ChessPiece) -> void:
	self.pieceType = chessPiece
	self.isEmpty = false
	chessPiece.pieceIdx = self.squareIdx
	# display the moved piece
	AddVisualPiece()

func DetachPiece() -> void:
	RemoveVisualPiece()
	self.pieceType = null
	self.isEmpty = true
	# remove the moved piece

func RemoveVisualPiece() -> void:
	var visualPieceInstance: Node3D = self.pieceType.visual
	self.visualSquare.remove_child(visualPieceInstance)

func AddVisualPiece() -> void:
	var visualPieceInstance: Node3D = self.pieceType.visual
	self.visualSquare.add_child(visualPieceInstance)

func ToggleVisualCircleVisibility(_visible) -> void:
	var circle: Sprite3D = self.visualSquare.get_node("Circle") as Sprite3D
	circle.visible = _visible

func ToggleRemoteVisualCircleVisibility(_visible) -> void:
	var circle: Sprite3D = self.visualSquare.get_node("Circle") as Sprite3D
	circle.visible = _visible

func ToggleVisualRedCircleVisibility(_visible) -> void:
	var circle: Sprite3D = self.visualSquare.get_node("RedCircle") as Sprite3D
	circle.visible = _visible

func ToggleVisualDownArrowVisibility(_visible) -> void:
	var downArr: Sprite3D = self.visualSquare.get_node("DownArrow") as Sprite3D
	downArr.visible = _visible

func ToggleVisualSwapKingCircleVisibility(_visible) -> void:
	var swapKingCircle: Sprite3D = self.visualSquare.get_node("SwapKingCircle") as Sprite3D
	swapKingCircle.visible = _visible

func SetVisualIdxLabel(idx: int) -> void:
	var label: Label3D = self.visualSquare.get_node("IdxLabel") as Label3D
	label.text = str(idx)

func GetPiece() -> ChessPiece:
	return self.pieceType
