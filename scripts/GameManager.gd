extends Node3D


var chessBoard = ChessBoard.new()

@onready var visualChessBoard = $ChessBoard
@onready var visualSpringArm3D = $ChessBoard/SpringArm3D
@onready var visualWhiteScoreLabel: Label = $UI/HBoxContainer/WhiteScore
@onready var visualBlackScoreLabel: Label = $UI/HBoxContainer2/BlackScore
@onready var leftButtonPressed: bool = false
@export var CAMERA_ROTATION_SPEED: float = 0.02


# Called when the node enters the scene tree for the first time.
func _ready():
	chessBoard.InitTheBoard(visualChessBoard)
	
	visualWhiteScoreLabel.text = str(chessBoard.InitWhitePiecesScore())
	visualBlackScoreLabel.text = str(chessBoard.InitBlackPiecesScore())


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






