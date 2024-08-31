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

var serverUrl := "ws://localhost:8080"


func ConnectToMatchMakingServer():
	var error = client.ConnectToURL(serverUrl)

	if error != OK:
		print("Error connecting to server: %s" % [serverUrl])
		set_process(false)
		

func _ready():
	print("Attempting to connect to server")
	client.SetConnectionClosedToServerCallback(OnWebSocketConnectionClosed)
	client.SetMessageReceivedFromTheServerCallback(OnWebSocketMessageReceived)
	ConnectToMatchMakingServer()

func OnWebSocketConnectionClosed():
	var ws = client.GetSocket()
	print("Disconnected from server with code %s and reason %s" % [ws.get_close_code(), ws.get_close_reason()])

func OnWebSocketMessageReceived(message):
	var json = JSON.parse_string(message)
	var data = json["operation"]["data"]
	print("receive message data: %s" % [data])

	if json["operation"]["service"] == "connection":
		print("receive connection data: %s" % [data])
		client.playerDictionary = data

	if json["operation"]["service"] == "matchmaking":
		var state = json["operation"]["state"]
		if state == "finding":
			client.playerDictionary = data
		elif state == "waiting":
			print("waiting for confirmation")
			confirmPanel.visible = true
			var players = data["players"]
			client.playerDictionary = players.filter(func(p): return p["info"]["id"] == client.playerDictionary["info"]["id"])[0]
			client.opponentDictionary = players.filter(func(p): return p["info"]["id"] != client.playerDictionary["info"]["id"])[0]
			
			client.matchId = data["matchId"]

			if client.playerDictionary["role"] == "black":
				blackPlayerLabel.text = client.playerDictionary["info"]["name"]
				Constants.blackPlayer.SetIsMainSession()
			else:
				whitePlayerLabel.text = client.playerDictionary["info"]["name"]
				Constants.whitePlayer.SetIsMainSession()

			if client.opponentDictionary["role"] == "black":
				blackPlayerLabel.text = client.opponentDictionary["info"]["name"]
			else:
				whitePlayerLabel.text = client.opponentDictionary["info"]["name"]
			
			var dic = {
				operation = {
					service = "matchmaking",
					type = 'waitingtoconfirm',
					data = {
						matchId = client.matchId
					}
				},
			}

			var jsonMessage = JSON.stringify(dic)

			client.Send(jsonMessage)

		elif state == "waitingtoconfirm":
			print(data)
			var timer = data.timer
			textureProgressBar.value = timer

		elif state == "peerconfirmed":
			var role = data["role"]
			if role == "black":
				blackPlayerClockImage.visible = false
				blackPlayerConfirmImage.visible = true
				return
			whitePlayerClockImage.visible = false
			whitePlayerConfirmImage.visible = true
			return

		elif state == "matchconfirmed":
			print(data)
			get_node("/root/SceneManager").switch_scene()


func OnWebSocketClientConnected():
	print("Successfully connected to server: %s" % [serverUrl])


func OnWebSocketSendMessage():
	if yourNameInput.text == "": return
	findMatchButton.disabled = true
	findMatchButton.text = "Finding..."
	client.playerDictionary["info"]["name"] = yourNameInput.text
	var dic = {
		operation = {
		  service = "matchmaking",
		  type = 'findmatch',
		  data = client.playerDictionary
		},
	}

	var jsonMessage = JSON.stringify(dic)
	print("send message findmatch: %s" % [jsonMessage])
	client.Send(jsonMessage)


func OnWebSocketSendMessageAcceptMatching():
	acceptMatching.disabled = true
	acceptMatching.text = "Waiting for opponent to accept..."
	var dic = {
		operation = {
		  service = "matchmaking",
		  type = 'peerconfirmed',
		  data = {
			id = client.playerDictionary["info"]["id"],
			role = client.playerDictionary["role"],
			matchId = client.matchId,
		  }
		},
	}

	var jsonMessage = JSON.stringify(dic)
	print("send message peerconfirmed: %s" % [jsonMessage])
	client.Send(jsonMessage)
