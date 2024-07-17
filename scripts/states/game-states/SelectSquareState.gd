extends StateBase

class_name SelectSquareState

func enter(data=null):
	
	# check if the square is of the player role or not

	var pieceType
	var playerRole

	# get the clicked square
	var square = data as ChessSquare

	if Constants.castlingData.nextSquares.has(square):
		stateMachine.switchTo(Constants.STATES.RULES.SwitchTheKingAndRookState, square)
		return

	# Determine whether the selected square contains a piece or not
	if square.GetPiece():
		var piece: ChessPiece = square.GetPiece()
		# Determine whether the piece is for the white or black player role
		if square.GetPiece().isBlackPiece:
			pieceType = Constants.blackPlayerLabel
		else:
			pieceType = Constants.whitePlayerLabel

		# then check the role to determine whether we should setting the selected square variable or not.
		# The selected square should be set only if the current clicked square contains the piece and for the current
		# player role._add_constant_force
		playerRole = Player.CheckRole(pieceType)

		# this if statement means that the clicked square is for the current player role
		if playerRole:
			if Constants.enPassantData.leftPawn != piece and Constants.enPassantData.rightPawn != piece:
				stateMachine.gameUI.ToggleShowHighlightSwapPawnCircle(false)

			if not piece is King:
				stateMachine.gameUI.ToggleShowHighlightSwapKingCircles(false)

			Constants.selectedSquare = square
			HandleSquareSelection()
			stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
			return
		elif CheckForExistingSquare(square):
			return
	
	# for else we have two cases
	if Constants.selectedSquare != null:

		if CheckForExistingSquare(square):
			return

		stateMachine.switchTo(Constants.STATES.GAME.WaitingState)
		
	pass

func CheckForExistingSquare(chessSquare: ChessSquare) -> bool:

	if Constants.enPassantData.nextSquare == chessSquare:
		stateMachine.switchTo(Constants.STATES.RULES.EnPassantState, Constants.selectedSquare)
		return true

	if Constants.targetSquares.has(chessSquare):
		Constants.enPassantData = {
			'leftPawn': null,
			'rightPawn': null,
			'prevPawnSquareIdx': - 1,
			'nextSquare': null,
		}
		# switch to take the place of the opposite piece state
		var takeOppositePlaceData = {
			"currentSquare": Constants.selectedSquare,
			"nextSquare": chessSquare
		}
		stateMachine.switchTo(Constants.STATES.GAME.TakeOppositePlaceState, takeOppositePlaceData)
		return true

	if Constants.nextSquares.has(chessSquare):
		Constants.enPassantData = {
			'leftPawn': null,
			'rightPawn': null,
			'prevPawnSquareIdx': - 1,
			'nextSquare': null,
		}
		# switch places state
		var switchPlacesData = {
			"currentSquare": Constants.selectedSquare,
			"nextSquare": chessSquare
		}
		stateMachine.switchTo(Constants.STATES.GAME.SwitchPlacesState, switchPlacesData)
		return true
	return false

func HandleSquareSelection():
	if not stateMachine.gameUI.visibleHighlightArrows.has(Constants.selectedSquare):
		stateMachine.gameUI.ClearHighlightArrows()
		stateMachine.gameUI.ClearHighlightCircles(Constants.selectedSquare)

	SelectNewSquare()

func SelectNewSquare() -> void:
	# get the type of the current piece
	var piece = Constants.selectedSquare.GetPiece()
	
	var nextCoordinates = piece.GetNextPositions()
	var nextPositions = nextCoordinates.nextPositions
	if piece is King:
		nextPositions = piece.FilterPositionByOtherPiecesPositions(nextPositions)
	if nextCoordinates.withSpecialMovement:
		Constants.nextSquares = Constants.FilterBlockedDirections(nextPositions, piece)
	else:
		Constants.nextSquares = FilterSimilarPieces(nextPositions, piece)

	if not piece is Pawn:
		Constants.targetSquares = GetAllOppositePieces(Constants.nextSquares, piece)
	else:
		var pawn: Pawn = piece
		var nextSquares = HandlePawnNextTargets(pawn)
		Constants.targetSquares = GetAllOppositePieces(nextSquares, pawn)

	stateMachine.gameUI.visibleHighlightArrows = Constants.targetSquares
	stateMachine.gameUI.visibleHighlightCircles = Constants.nextSquares
	stateMachine.gameUI.ToggleShowHighlightArrows(true)
	stateMachine.gameUI.ToggleShowHighlightCircles(true)

func HandlePawnNextTargets(pawn: Pawn) -> Array:
	var nextPositions: Array
	nextPositions = pawn.GetAllOppositePiecePositions().nextPositions
	nextPositions = FilterSimilarPieces(nextPositions, pawn)
		
	return nextPositions

## Get all possible positions for this current piece after been filtered by similar pieces
func FilterSimilarPieces(nextPositions, chessPiece) -> Array[ChessSquare]:
	var nextSquares: Array[ChessSquare] = []
	for pos in nextPositions:
		var nextSquare = Constants.GRID[pos.nextCol]
		if not nextSquare.isEmpty and nextSquare.pieceType.CanMove(chessPiece):
			nextSquares.append(nextSquare)
		if nextSquare.isEmpty:
			nextSquares.append(nextSquare)
	
	return nextSquares

func GetAllOppositePieces(_nextSquares, piece) -> Array[ChessSquare]:
	var _targetSquares: Array[ChessSquare] = []
	for square in _nextSquares:
		if not square.isEmpty:
			if not AreThePiecesTheSameColor(piece, square.pieceType):
				_targetSquares.append(square)

	return _targetSquares

func AreThePiecesTheSameColor(p1: ChessPiece, p2: ChessPiece) -> bool:
	return int(p1.isBlackPiece) + int(p2.isBlackPiece) == 2
