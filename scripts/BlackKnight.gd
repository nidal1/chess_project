extends ChessPiece


class_name BlackKnight

func _init(visual, pieceIdx, isBlackPiece = false):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = isBlackPiece
