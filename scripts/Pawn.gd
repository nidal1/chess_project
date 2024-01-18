extends ChessPiece


class_name Pawn

var isTheFirstMove : bool = true

func _init(_visual, _pieceIdx, _isBlackPiece = true):
	self.visual = _visual.instantiate()
	self.pieceIdx = _pieceIdx
	self.isBlackPiece = _isBlackPiece
	self.pieceCost = 1

func GetAllOppositePiecePositions():
	var direction
	if self.isBlackPiece:
		direction = 1
	else:
		direction = -1
	
	return {
		"row": 1 * direction,
		"col": [pieceIdx + 8 * direction + 1 , pieceIdx + 8 * direction - 1]
	}
	

func GetTheNextPosition():

	var direction
	if self.isBlackPiece:
		direction = 1
	else:
		direction = -1

	if isTheFirstMove:
		return [{
			"row" : 0,
			"col": []
		},
		{
			"row" : 1 * direction,
			"col": [pieceIdx + 8 * direction]
		},
		{
			"row" : 2 * direction,
			"col": [pieceIdx + 8 * 2 * direction]
		},
		]
	else:
		return [{
			"row" : 0,
			"col": []
		},
		{
			"row" : 1 * direction,
			"col": [pieceIdx + 8 * direction]
		}
		]
