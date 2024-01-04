extends Node3D


var chessBoard = ChessBoard.new()

@onready var visualChessBoard = $ChessBord
@onready var visualSpringArm3D = $ChessBord/SpringArm3D

@onready var visualBlackChessSquare = preload("res://sceens/SquareBlack.tscn")
@onready var visualWhiteChessSquare = preload("res://sceens/SquareWhite.tscn")
@onready var visualRedChessSquare = preload("res://sceens/SquareRed.tscn")

@onready var leftButtonPressed: bool = false
@export var CAMERA_ROTATION_SPEED: float = 0.02


# Called when the node enters the scene tree for the first time.
func _ready():
	chessBoard.OnObservingTheClickingOnSquares()
	chessBoard.InitBoardSquares()
	chessBoard.InitPieces()
	RenderChessSqueres(chessBoard.GRID)
	RenderPieces(chessBoard.GRID)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func RenderChessSqueres(grid) -> void:
	var idx = 0
	for row in chessBoard.ROWS:
		for col in chessBoard.COLS:
			var square: ChessSquare = grid[idx]
			var instance: Node3D
#			if idx >=48 and idx <=64:
#				instance = visualRedChessSquare.instantiate()
#			else:
			if square.squareType == "black":
				instance = visualBlackChessSquare.instantiate()
			else:
				instance = visualWhiteChessSquare.instantiate()
				
			instance.position.x += col
			instance.position.z += row
			visualChessBoard.add_child(instance)
			square.AssingVisualSquare(instance)
			idx += 1

func RenderPieces(grid) -> void:
	var idx = 0
	for cell in grid:
		var square: ChessSquare = cell
		if square.isEmpty == false:
			var visualPieceInstance:Node3D = square.pieceType.visual
			visualPieceInstance.position.y += 0.5
			if square.visualSquare != null and idx == square.pieceType.pieceIdx:
				square.visualSquare.add_child(visualPieceInstance)
		idx += 1
#			await get_tree().create_timer(1.0).timeout


func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		leftButtonPressed = event.is_pressed()
	if leftButtonPressed and event is InputEventMouseMotion:
		var xVelocity: float = clamp(event.get_relative().x,-CAMERA_ROTATION_SPEED,CAMERA_ROTATION_SPEED) 
		# var yVelocity: float = clamp(event.get_relative().y,-CAMERA_ROTATION_SPEED,CAMERA_ROTATION_SPEED) 
		if xVelocity:
			var yPosition = Vector3.MODEL_TOP
			visualSpringArm3D.global_rotate(yPosition, xVelocity)
#		if yVelocity:
#			var xPosition = Vector3.MODEL_FRONT
#			visualSpringArm3D.global_rotate(xPosition, yVelocity)






