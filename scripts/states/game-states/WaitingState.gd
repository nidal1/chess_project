extends StateBase

func enter(data = null):
	super.enter(null)

	if Constants.theKingUnderAttackData.isTheKingUnderAttack and not Constants.checkmateData.checkmateChecked:
		Constants.observingClickingOnSquares.disconnect(HandleClickingSquare)
		stateMachine.switchTo(Constants.STATES.RULES.CheckmateState)
		return

	else: self.OnObservingTheClickingOnSquares()

func OnObservingTheClickingOnSquares() -> void:
	if not Constants.observingClickingOnSquares.is_connected(HandleClickingSquare):
		Constants.observingClickingOnSquares.connect(HandleClickingSquare)


func HandleClickingSquare(chessSquare) -> void:
	if not Player.CheckRole(Constants.mainPlayer.playerLabel):
		return

	if Constants.theKingUnderAttackData.isTheKingUnderAttack:
			stateMachine.switchTo(Constants.STATES.RULES.KingUnderAttackState, chessSquare)
			return

	if not chessSquare.isEmpty:
		var piece = chessSquare.GetPiece()

		if (not piece is King) and (Constants.theKingUnderAttackData.isTheKingUnderAttack):
			return

		if piece is Pawn:
			stateMachine.switchTo(Constants.STATES.GAME.SelectThePawnSquareState, chessSquare)
			return

		if piece is King and not piece.isMoved:
			stateMachine.switchTo(Constants.STATES.GAME.SelectKingSquareState, chessSquare)
			return

	stateMachine.switchTo(Constants.STATES.GAME.SelectSquareState, chessSquare)


func OnWebSocketMessageReceived(message) -> void:
	super.OnWebSocketMessageReceived(message)

	var json = JSON.parse_string(message)
	var operation = json["operation"]
	var service = operation["service"]
	var type = operation["type"]
	var data = operation["data"]

	if service == "playing":
		if type == "selectsquare":
			OnReceiveMessageSelectSquare(data)

		if type == "switchplace":
			OnReceiveMessageSwitchSquare(data)

		if type == "takeoppositeplace":
			OnReceiveMessageTakeOpponentPlace(data)

		if type == "switchking":
			OnReceiveMessageSwitchKing(data)

		if type == "promotepawn":
			OnReceiveMessagePromoteAPawn(data)

		if type == "enpassant":
			OnReceiveMessageEnPassant(data)

		if type == "takeenpassantplace":
			OnReceiveMessageTakeEnPassantPlace(data)

func OnReceiveMessageSelectSquare(data) -> void:
	stateMachine.gameUI.ClearRemoteHighlightCircles()
	var square: ChessSquare = Constants.GRID[data.selectedSquareIndex]
	stateMachine.gameUI.visibleRemoteHighlightCircles.append(square)
	stateMachine.gameUI.ToggleShowRemoteHighlightCircles(true)

func OnReceiveMessageSwitchSquare(data) -> void:
	var currentSquare: ChessSquare = Constants.GRID[data.selectedSquareIndex]
	var nextSquare: ChessSquare = Constants.GRID[data.nextSquareIndex]
	if not stateMachine.gameUI.visibleRemoteHighlightCircles.has(currentSquare):
		OnReceiveMessageSelectSquare(data)
	
	stateMachine.gameUI.ClearRemoteHighlightCircles()

	Constants.HandleMovePiece(nextSquare, currentSquare)

	var piece = nextSquare.GetPiece()

	piece.isMoved = true

	if piece is Pawn:
		var pawn = piece as Pawn
		if pawn.IsThePieceReachesTheSides(pawn):
			return

	Player.CurrentPlayer.playerPreviousPiece = piece

	Constants.SwitchPlayers()

	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

	Constants.CheckIfTheKingIsUnderAttack(stateMachine.gameUI)

	if not Constants.theKingUnderAttackData.isTheKingUnderAttack:
		stateMachine.gameUI.ToggleShowHighlightRedCircles(false)

	self.enter()

func OnReceiveMessageTakeOpponentPlace(data) -> void:
	var currentSquare: ChessSquare = Constants.GRID[data.selectedSquareIndex]
	var nextSquare: ChessSquare = Constants.GRID[data.nextSquareIndex]
	if not stateMachine.gameUI.visibleRemoteHighlightCircles.has(currentSquare):
		OnReceiveMessageSelectSquare(data)

	stateMachine.gameUI.ClearRemoteHighlightCircles()

	var piece: ChessPiece = currentSquare.GetPiece()

	var removedPiece = Constants.TakePlaceOfOpponentPiece(nextSquare, currentSquare)
	Player.NextPlayer.RemovePiece(removedPiece)

	Constants.UpdatePlayerScore(
		stateMachine.gameUI.UpdateBlackScore,
		stateMachine.gameUI.UpdateWhiteScore
	)

	if piece is Pawn:
		var pawn = piece as Pawn
		if pawn.IsThePieceReachesTheSides(pawn):
			return

	Player.CurrentPlayer.playerPreviousPiece = piece

	Constants.SwitchPlayers()

	Constants.CheckIfTheKingIsUnderAttack(stateMachine.gameUI)

	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

	if not Constants.theKingUnderAttackData.isTheKingUnderAttack:
		stateMachine.gameUI.ToggleShowHighlightRedCircles(false)

	stateMachine.gameUI.SetToInvisible()

	self.enter()

func OnReceiveMessageSwitchKing(data) -> void:
	var kingSquareIndex = data["currentSquare"]
	var nextKingSquareIdx = data["nextKingSquare"]
	var nextRookSquareIdx = data["nextRookSquare"]
	var rookIndex = data["rookIndex"]
	var kingSquare: ChessSquare = Constants.GRID[kingSquareIndex]
	var nextKingSquare: ChessSquare = Constants.GRID[nextKingSquareIdx]
	var nextRookSquare: ChessSquare = Constants.GRID[nextRookSquareIdx]
	var rookSquare: ChessSquare = Constants.GRID[rookIndex]

	if not stateMachine.gameUI.visibleRemoteHighlightCircles.has(kingSquare):
		OnReceiveMessageSelectSquare(data)

	stateMachine.gameUI.ClearRemoteHighlightCircles()

	var king: ChessPiece = kingSquare.GetPiece()
	var rook: ChessPiece = rookSquare.GetPiece()

	kingSquare.DetachPiece()
	rookSquare.DetachPiece()

	nextKingSquare.AssignPiece(king)
	nextRookSquare.AssignPiece(rook)

	Player.CurrentPlayer.playerPreviousPiece = king

	Constants.SwitchPlayers()

	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

	self.enter()

func OnReceiveMessagePromoteAPawn(data) -> void:
	var piece: ChessPiece
	var promotedPiece = data["promotedPiece"]
	var promotedPieceIndex = data["promotedPieceIndex"] as int
	var role = data["role"]

	var isBlackPlayer = true if role == Constants.blackPlayerLabel else false

	match promotedPiece:
		"queen":
			piece = Queen.new(promotedPieceIndex, isBlackPlayer)
		"rook":
			piece = Rook.new(promotedPieceIndex, isBlackPlayer)
		"bishop":
			piece = Bishop.new(promotedPieceIndex, isBlackPlayer)
		"knight":
			piece = Knight.new(promotedPieceIndex, isBlackPlayer)
		

	var promotedPiceSquare: ChessSquare = Constants.GRID[promotedPieceIndex]

	Player.CurrentPlayer.RemovePiece(promotedPiceSquare.GetPiece())
	
	promotedPiceSquare.DetachPiece()
	promotedPiceSquare.AssignPiece(piece)

	Player.CurrentPlayer.AppendPiece(piece)

	Player.CurrentPlayer.playerPreviousPiece = piece

	Constants.SwitchPlayers()

	Constants.UpdatePlayerScore(
		stateMachine.gameUI.UpdateBlackScore,
		stateMachine.gameUI.UpdateWhiteScore
	)

	Constants.CheckIfTheKingIsUnderAttack(stateMachine.gameUI)

	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

	if not Constants.theKingUnderAttackData.isTheKingUnderAttack:
		stateMachine.gameUI.ToggleShowHighlightRedCircles(false)

	Constants.ClearData()
	stateMachine.gameUI.SetToInvisible()

	self.enter()

func OnReceiveMessageEnPassant(data) -> void:
	var leftSquare: ChessSquare = Constants.GRID[data.targetSquareIndex + 1]
	var rightSquare: ChessSquare = Constants.GRID[data.targetSquareIndex - 1]

	Constants.enPassantData.prevPawnSquareIdx = data["pawnSquareIndex"]

	Constants.enPassantData.leftPawn = leftSquare.GetPiece() if leftSquare.GetPiece() is Pawn else null
	Constants.enPassantData.rightPawn = rightSquare.GetPiece() if rightSquare.GetPiece() is Pawn else null

	OnReceiveMessageSwitchSquare({
		"selectedSquareIndex": data["pawnSquareIndex"],
		"nextSquareIndex": data["targetSquareIndex"],
	})

func OnReceiveMessageTakeEnPassantPlace(data) -> void:
	var currentSquare: ChessSquare = Constants.GRID[data.selectedSquareIndex]

	if not stateMachine.gameUI.visibleRemoteHighlightCircles.has(currentSquare):
		OnReceiveMessageSelectSquare(data)

	stateMachine.gameUI.ClearRemoteHighlightCircles()

	var pawn: Pawn = currentSquare.GetPiece()

	var nextSquare: ChessSquare = Constants.GRID[data.nextSquareIndex]
	var opponentSquare: ChessSquare = Constants.GRID[data.targetSquareIndex]


	Constants.TakeEnPassantPlace(currentSquare, nextSquare, opponentSquare, pawn)

	Constants.UpdatePlayerScore(
		stateMachine.gameUI.UpdateBlackScore,
		stateMachine.gameUI.UpdateWhiteScore
	)

	Player.CurrentPlayer.playerPreviousPiece = pawn

	Constants.SwitchPlayers()

	Constants.CheckIfTheKingIsUnderAttack(stateMachine.gameUI)

	stateMachine.gameUI.UpdatePlayerRole(Player.CurrentPlayer.playerLabel)

	if not Constants.theKingUnderAttackData.isTheKingUnderAttack:
		stateMachine.gameUI.ToggleShowHighlightRedCircles(false)

	Constants.ClearData()
	stateMachine.gameUI.SetToInvisible()

	self.enter()
