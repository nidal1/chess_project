extends Node

class_name ChessPiece

var pieceIdx: int
var visual: Node3D
var isBlackPiece: bool
var canMove: bool = false
var movementAmount

#func SwitchColor():
#	var material:Material = StandardMaterial3D.new()
#	if isBlackPiece:
#		material.albedo_color = Color(255,255,255)
#	else:
#		material.albedo_color = Color(0,0,0)
#	visual.get_node("RootNode").get_child(0).set_surface_override_material(0, material)


func MoveTo():
	pass
	

func _ready():
	pass


func _process(delta):
	pass
