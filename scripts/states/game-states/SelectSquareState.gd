extends StateBase

class_name SelectSquareState

func enter(data=null):
	
	# check if the square is of the player role or not

	var pieceType
	var playerRole

	# get the clicked square
	var square = data as ChessSquare

	# Determine whether the selected square contains a piece or not
	if square.GetPiece():
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
	if Constants.targetSquares.has(chessSquare):
		# switch to take the place of the opposite piece state
		var takeOppositePlaceData = {
			"currentSquare": Constants.selectedSquare,
			"nextSquare": chessSquare
		}
		stateMachine.switchTo(Constants.STATES.GAME.TakeOppositePlaceState, takeOppositePlaceData)
		return true
		
	if Constants.nextSquares.has(chessSquare):
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
	var pieceIdx = Constants.selectedSquare.GetPiece().pieceIdx
		# get the row index of the current piece
	var selectedRow = stateMachine.gameRules.LocalizationOfSelectedPiece(pieceIdx)
	
	if piece.withSpecialMovement:
		Constants.nextSquares = HandleSpecialMovementPiece(piece, selectedRow)
	else:
		# calculate the incoming positions
		var coordinations = piece.GetTheNextPosition()
		Constants.nextSquares = HandleNonSpecialMovementPiece(coordinations, piece, selectedRow)

	if not piece is Pawn:
		Constants.targetSquares = GetAllOppositePieces(Constants.nextSquares, piece)
	else:
		piece = piece as Pawn
		var coordinations = piece.GetAllOppositePiecePositions()
		var nextSquares = HandleNonSpecialMovementPiece(coordinations, piece, selectedRow)
		Constants.targetSquares = GetAllOppositePieces(nextSquares, piece)

	# blackKing.OnCheckTheCheckRule(targetSquares)
	# whiteKing.OnCheckTheCheckRule(targetSquares)
	stateMachine.gameUI.visibleHighlightArrows = Constants.targetSquares
	stateMachine.gameUI.visibleHighlightCircles = Constants.nextSquares
	stateMachine.gameUI.ToggleShowHighlightArrows(true)
	stateMachine.gameUI.ToggleShowHighlightCircles(true)

# Pawn, knight, king
## @params: piece[ChessPiece], selectedRow[int]
## @return: Array[ChessPiece] next positions
func HandleNonSpecialMovementPiece(coordinations: Array, piece: ChessPiece, selectedRow: int) -> Array:
	var nextPositions: Array
	if coordinations.size():
		nextPositions = HandleNextPositions(coordinations, selectedRow)
		nextPositions = FilterSimilarPieces(nextPositions, piece)
	return nextPositions

## Queen, Rook,  Bishop
func HandleSpecialMovementPiece(piece: ChessPiece, selectedRow: int) -> Array:
	# calculate the incoming positions
	var coordinations = piece.GetTheNextPosition()
	var nextPositions: Array
	if coordinations.size():
		nextPositions = HandleNextPositions(coordinations, selectedRow)
		nextPositions = FilterBlockedDirections(nextPositions, piece)
	
	return nextPositions

## Get all possible positions for this current piece
func HandleNextPositions(coordinations, currentRowPosition) -> Array:
	var nextSquares: Array = []
	for coor in coordinations:
		var nextSelectedRow = currentRowPosition + coor.row
		var isNextSelectedRowBetweenEdges = nextSelectedRow > 0 and nextSelectedRow <= stateMachine.gameRules.ROWS
		if isNextSelectedRowBetweenEdges:
			var boundaries = stateMachine.gameRules.GetTheBoundariesOfASelectedRow(nextSelectedRow)
			var selectedCol = coor.col
			var firstIdx = boundaries[0]
			var lastIdx = boundaries[1]
			var isSelectedColBetweenEdges = selectedCol >= firstIdx and selectedCol <= lastIdx
			if isSelectedColBetweenEdges:
				var nextSquare: ChessSquare = Constants.GRID[selectedCol]
				nextSquares.append({
					"nextSquare": nextSquare,
					"direction": coor.direction if coor.has("direction") else null
					})

	return nextSquares

## Get all possible positions for this current piece after been filtered by blocked directions
func FilterBlockedDirections(nextPositions, chessPiece) -> Array[ChessSquare]:
	var blockedDirections = []
	var nextSquares: Array[ChessSquare] = []
	for pos in nextPositions:
		var nextSquare = pos.nextSquare
		if not nextSquare.isEmpty:
			if nextSquare.pieceType.CanMove(chessPiece) and not blockedDirections.has(pos.direction):
				nextSquares.append(nextSquare)
			blockedDirections.append(pos.direction)

		else:
			if not blockedDirections.has(pos.direction):
				nextSquares.append(nextSquare)
			
	return nextSquares
## Get all possible positions for this current piece after been filtered by similar pieces
func FilterSimilarPieces(nextPositions, chessPiece) -> Array[ChessSquare]:
	var nextSquares: Array[ChessSquare] = []
	for pos in nextPositions:
		var nextSquare = pos.nextSquare
		if not nextSquare.isEmpty and nextSquare.pieceType.CanMove(chessPiece):
			nextSquares.append(nextSquare)
		if nextSquare.isEmpty:
			nextSquares.append(nextSquare)
	
	return nextSquares

func FilterSquares(_nextSquares) -> Array[ChessSquare]:
	var filteredSquares: Array[ChessSquare] = []
	for square in _nextSquares:
		if square.isEmpty:
			filteredSquares.append(square)

	return filteredSquares

func GetAllOppositePieces(_nextSquares, piece) -> Array[ChessSquare]:
	var _targetSquares: Array[ChessSquare] = []
	for square in _nextSquares:
		if not square.isEmpty:
			if not AreThePiecesTheSameColor(piece, square.pieceType):
				_targetSquares.append(square)

	return _targetSquares

func AreThePiecesTheSameColor(p1: ChessPiece, p2: ChessPiece) -> bool:
	return int(p1.isBlackPiece) + int(p2.isBlackPiece) == 2