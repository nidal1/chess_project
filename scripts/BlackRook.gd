extends ChessPiece


class_name BlackRook

func _init(visual, pieceIdx, isBlackPiece = false):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = isBlackPiece
