extends ChessPiece


class_name WhiteBishop

func _init(visual, pieceIdx, _isBlackPiece = true):
	self.visual = visual.instantiate()
	self.pieceIdx = pieceIdx
	self.isBlackPiece = _isBlackPiece
	self.withSpicialMovement = false

func MoveToLastPosition(nextPiece: ChessPiece):
	for i in range(0, 8):
		if not nextPiece and nextPiece.isBlackPiece != self.isBlackPiece:
