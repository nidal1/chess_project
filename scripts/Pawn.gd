extends ChessPiece


class_name Pawn

func _init(visual, pieceIdx, isBlackPiece = false):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = isBlackPiece
	self.movementAmount = 8


func MoveTo():
	if movementAmount > 0:
		self.pieceIdx += movementAmount
