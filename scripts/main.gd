extends Node3D

@onready var visualSpringArm3D = $ChessBoard/SpringArm3D
@onready var leftButtonPressed: bool = false
@export var CAMERA_ROTATION_SPEED: float = 0.02

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		leftButtonPressed = event.is_pressed()
	elif leftButtonPressed and event is InputEventMouseMotion:
		var xVelocity: float = clamp(event.get_relative().x, -CAMERA_ROTATION_SPEED, CAMERA_ROTATION_SPEED)
		# var yVelocity: float = clamp(event.get_relative().y,-CAMERA_ROTATION_SPEED,CAMERA_ROTATION_SPEED) 
		if xVelocity:
			var yPosition = Vector3.MODEL_TOP
			visualSpringArm3D.global_rotate(yPosition, xVelocity)
	#		if yVelocity:
	#			var xPosition = Vector3.MODEL_FRONT
	#			visualSpringArm3D.global_rotate(xPosition, yVelocity)
