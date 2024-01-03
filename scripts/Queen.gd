extends ChessPiece


class_name Queen

func _init(visual, pieceIdx, isBlackPiece = false):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = isBlackPiece
