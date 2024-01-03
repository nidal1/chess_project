extends ChessPiece


class_name WhiteKnight

func _init(visual, pieceIdx, isBlackPiece = false):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = isBlackPiece
