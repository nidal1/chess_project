extends Control

@onready var client: WSClient = get_node("/root/SceneManager/WSC")
@onready var session: Node = get_node("/root/Session")
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

var serverUrl := "ws://localhost:8080"

func _connect_to_matchmaking_server():
	var error = client.ConnectToURL(serverUrl) # Assuming this is a method on your WSClient

	if error != OK:
		print("Error connecting to server: %s" % [serverUrl])
		set_process(false)


func _ready():
	print("Attempting to connect to server")
	client.connection_closed.connect(_on_web_socket_connection_closed)
	client.message_received.connect(_on_web_socket_message_received)
	_connect_to_matchmaking_server()
	yourNameInput.text = session.playerDictionary.get("info", {}).get("username", "")

func _on_web_socket_connection_closed():
	var ws = client.GetSocket() # Assuming this is a method on your WSClient
	print("Disconnected from server with code %s and reason %s" % [ws.get_close_code(), ws.get_close_reason()])

func _on_web_socket_message_received(message):
	var parse_result = JSON.parse_string(message)
	if not parse_result:
		printerr("Error parsing JSON message from server: ", message)
		return

	var operation = parse_result.get("operation")
	if not operation:
		printerr("Invalid message format, 'operation' key missing.")
		return
	
	var data = operation.get("data")
	print("Received message data: %s" % [data])

	# Using a match statement is cleaner for dispatching.
	# If you are on Godot 3, you can use an if/elif/else chain.
	match operation.get("service"):
		"connection":
			_handle_connection_message(data)
		"matchmaking":
			_handle_matchmaking_message(operation)

func _handle_connection_message(data):
	print("Received connection data: %s" % [data])
	session.playerDictionary = data

func _handle_matchmaking_message(operation):
	var state = operation.get("state")
	var data = operation.get("data")
	
	match state:
		"finding":
			session.playerDictionary = data
		"waiting":
			_handle_match_waiting(data)
		"waitingtoconfirm":
			print(data)
			textureProgressBar.value = data.get("timer", 0)
		"peerconfirmed":
			_handle_peer_confirmed(data)
		"matchconfirmed":
			print(data)
			get_node("/root/SceneManager").switch_scene()

func _handle_match_waiting(data):
	print("Waiting for confirmation")
	confirmPanel.visible = true
	
	var my_id = session.playerDictionary["info"]["id"]
	for p in data.get("players", []):
		if p["info"]["id"] == my_id:
			session.playerDictionary = p
		else:
			session.opponentDictionary = p
	
	session.matchId = data.get("matchId")

	if session.playerDictionary["role"] == "black":
		blackPlayerLabel.text = session.playerDictionary["info"]["name"]
		whitePlayerLabel.text = session.opponentDictionary["info"]["name"]
		Constants.blackPlayer.SetIsMainSession()
	else:
		whitePlayerLabel.text = session.playerDictionary["info"]["name"]
		blackPlayerLabel.text = session.opponentDictionary["info"]["name"]
		Constants.whitePlayer.SetIsMainSession()
	
	var payload = {
		"operation": {
			"service": "matchmaking",
			"type": "waitingtoconfirm",
			"data": {"matchId": session.matchId}
		}
	}
	client.Send(JSON.stringify(payload))

func _handle_peer_confirmed(data):
	var role = data.get("role")
	if role == "black":
		blackPlayerClockImage.visible = false
		blackPlayerConfirmImage.visible = true
	elif role == "white":
		whitePlayerClockImage.visible = false
		whitePlayerConfirmImage.visible = true


func _on_web_socket_client_connected():
	# This function is defined but does not appear to be connected to any signal
	# or callback in _ready(). If your WSClient has a 'connected' signal,
	# you might want to connect it to this function.
	print("Successfully connected to server: %s" % [serverUrl])
	print(session.playerDictionary["info"]["username"])
	yourNameInput.text = session.playerDictionary["info"]["username"]


func _on_find_match_button_pressed():
	if yourNameInput.text == "": return
	findMatchButton.disabled = true
	findMatchButton.text = "Finding..."
	session.playerDictionary["info"]["username"] = yourNameInput.text
	var dic = {
		operation = {
		  service = "matchmaking",
		  type = 'findmatch',
		  data = session.playerDictionary
		},
	}

	var jsonMessage = JSON.stringify(dic)
	print("send message findmatch: %s" % [jsonMessage])
	client.Send(jsonMessage) # Assuming Send is a method on your WSClient


func _on_accept_matching_button_pressed():
	acceptMatching.disabled = true
	acceptMatching.text = "Waiting for opponent to accept..."
	var dic = {
		operation = {
		  service = "matchmaking",
		  type = 'peerconfirmed',
		  data = {
			id = session.playerDictionary["info"]["id"],
			role = session.playerDictionary["role"],
			matchId = session.matchId,
		  }
		},
	}

	var jsonMessage = JSON.stringify(dic)
	print("send message peerconfirmed: %s" % [jsonMessage])
	client.Send(jsonMessage) # Assuming Send is a method on your WSClient
