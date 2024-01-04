extends Node

class_name ChessPiece

var pieceIdx: int
var visual: Node3D
var isBlackPiece: bool
var withSpicialMovement: bool = true

#func SwitchColor():
#	var material:Material = StandardMaterial3D.new()
#	if isBlackPiece:
#		material.albedo_color = Color(255,255,255)
#	else:
#		material.albedo_color = Color(0,0,0)
#	visual.get_node("RootNode").get_child(0).set_surface_override_material(0, material)


func CanMove(other :ChessPiece) -> bool:
	if other:
		return int(self.isBlackPiece) + int(other.isBlackPiece) == 1
	else:
		return true
