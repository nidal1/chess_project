extends ChessPiece


class_name BlackBishop

func _init(visual, pieceIdx, _isBlackPiece = true):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = _isBlackPiece
