extends Control

@onready var client: WSClient = get_node("/root/SceneManager/WSC")
@onready var yourNameInput: TextEdit = %YourNameInput
@onready var confirmPanel: Panel = %ConfirmPanel
@onready var findMatchButton: Button = %FindMatchButton
@onready var acceptMatching: Button = %AcceptMatching
@onready var blackPlayerLabel: Label = %BlackPlayerLabel
@onready var whitePlayerLabel: Label = %WhitePlayerLabel
@onready var whitePlayerClockImage: TextureRect = %WhiteClockImage
@onready var blackPlayerClockImage: TextureRect = %BlackClockImage
@onready var whitePlayerConfirmImage: TextureRect = %WhiteConfirmImage
@onready var blackPlayerConfirmImage: TextureRect = %BlackConfirmImage
@onready var textureProgressBar: TextureProgressBar = %TextureProgressBar

var serverUrl := "ws://localhost:3000/game"


func _ready():
	if (client.lastState == WebSocketPeer.STATE_OPEN):
		print("Connected to server: %s" % [serverUrl])
		client.connection_closed.connect(_on_web_socket_connection_closed)
		client.message_received.connect(_on_web_socket_message_received)
		var username = Session.playerDictionary.get("info").get("displayName", "")
		yourNameInput.text = username
		return

func _on_web_socket_connection_closed():
	var ws = client.GetSocket() # Assuming this is a method on your WSClient
	print("Disconnected from server with code %s and reason %s" % [ws.get_close_code(), ws.get_close_reason()])

func _on_web_socket_message_received(message):
	print("Received message from server: %s" % [message])
	var wsr = WSResponse.new(message)
	if wsr.error:
		printerr("Error parsing JSON message from server: ", message)
		return
		
	match wsr.service:
		"matchmaking":
			_handle_matchmaking_message(wsr)

func _handle_connection_message(data):
	print("Received connection data: %s" % [data])
	Session.playerDictionary = data

func _handle_matchmaking_message(wsr: WSResponse):
	var operation = wsr.operation
	var data = wsr.data
	
	match operation:
		"peerfounded":
			if data:
				_handle_peer_founded(data)

		"waitingtoconfirm":
			if data:
				_handle_match_waiting(data)
				
		"peerconfirmed":
			if data:
				_handle_peer_confirmed(data)
		"matchconfirmed":
			if data:
				print("Match confirmed")
				print(data)
				get_node("/root/SceneManager").switch_scene()

func _handle_peer_founded(data):
	print("Peer founded")
	print(JSON.stringify(data))
	Session.matchId = data.get("matchId")
	Session.playerDictionary["username"] = data["mainPlayer"]["username"]
	Session.playerDictionary.role = data["mainPlayer"]["role"]

	Session.opponentDictionary["username"] = data["opponentPlayer"]["username"]
	Session.opponentDictionary.role = data["opponentPlayer"]["role"]

	confirmPanel.visible = true


	if Session.playerDictionary["role"] == "black":
		blackPlayerLabel.text = Session.playerDictionary.username
		whitePlayerLabel.text = Session.opponentDictionary.username
		
	else:
		whitePlayerLabel.text = Session.playerDictionary.username
		blackPlayerLabel.text = Session.opponentDictionary.username
		

func _handle_match_waiting(data):
	print("Waiting for confirmation")
	textureProgressBar.value = data.get("remaining", 0)
	

	# var my_id = Session.playerDictionary["info"]["id"]
	# for p in data.get("players", []):
	# 	if p["info"]["id"] == my_id:
	# 		Session.playerDictionary = p
	# 	else:
	# 		Session.opponentDictionary = p
	

func _handle_peer_confirmed(data):
	Session.matchId = data.get("matchId")

	var role = data["peer"]["role"]
	if role == "black":
		blackPlayerClockImage.visible = false
		blackPlayerConfirmImage.visible = true
		Constants.blackPlayer.SetIsMainSession()
	elif role == "white":
		whitePlayerClockImage.visible = false
		whitePlayerConfirmImage.visible = true
		Constants.whitePlayer.SetIsMainSession()


func _on_web_socket_client_connected():
	# This function is defined but does not appear to be connected to any signal
	# or callback in _ready(). If your WSClient has a 'connected' signal,
	# you might want to connect it to this function.
	print("Successfully connected to server: %s" % [serverUrl])
	print("_on_web_socket_client_connected: ", Session.playerDictionary["info"]["username"])
	yourNameInput.text = Session.playerDictionary["info"]["username"]


func _on_find_match_button_pressed():
	if yourNameInput.text == "": return
	findMatchButton.disabled = true
	findMatchButton.text = "Finding..."
	Session.playerDictionary.username = yourNameInput.text

	var out = WSSendMessage.new("findmatch", Session.playerDictionary["username"]).stringify()
	print("send message findmatch: %s" % [out])
	client.Send(out) # Assuming Send is a method on your WSClient


func _on_accept_matching_button_pressed():
	acceptMatching.disabled = true
	var role = Session.playerDictionary.role
	if role == "black":
		blackPlayerClockImage.visible = false
		blackPlayerConfirmImage.visible = true
	else:
		whitePlayerClockImage.visible = false
		whitePlayerConfirmImage.visible = true


	acceptMatching.text = "Waiting for opponent to accept..."

	var dic = {
			matchId = Session.matchId,
			role = role
		  }

	var out = WSSendMessage.new("peerconfirmed", dic).stringify()
	print("send message peerconfirmed: %s" % [out])
	

	client.Send(out) # Assuming Send is a method on your WSClient
