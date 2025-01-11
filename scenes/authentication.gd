extends Control

@onready var client: WSClient = get_node("/root/SceneManager/WSC")

@onready var signInContainer = %SignInContainer
@onready var signIinErrorMessageLabel = %SignInErrorMessageLabel
@onready var emailInput = %EmailInput
@onready var passwordInput = %PasswordInput
@onready var loginButton = %LoginButton
@onready var registerButton = %RegisterButton
@onready var userNameContainer = %UserNameContainer
@onready var usernameErrorMessage_label_2 = %UsernameErrorMessageLabel2
@onready var usernameInput = %UsernameInput
@onready var nextButton = %NextButton

var serverUrl := "ws://localhost:8080"

func ConnectToMatchMakingServer():
	var error = client.ConnectToURL(serverUrl)

	if error != OK:
		print("Error connecting to server: %s" % [serverUrl])
		set_process(false)
	else:
		print("connected to server: %s" % [serverUrl])

func _ready():
	print("Attempting to connect to server")
	client.SetConnectionClosedToServerCallback(OnConnectionClosed)
	client.SetMessageReceivedFromTheServerCallback(OnClientReceivedMessage)
	ConnectToMatchMakingServer()


func OnLoginButtonPressed():

	if not (client.lastState == WebSocketPeer.STATE_OPEN):
		signIinErrorMessageLabel.text = 'Error connecting to server please try again.'
		return

	var email = emailInput.text
	var password = passwordInput.text

	if not (email and password):
		signIinErrorMessageLabel.text = "Email and password are required"
		return

	var data = {
		email = email,
		password = password
	}

	var output = WSSendMessage.new("authentication", "signin", data).stringify()

	client.Send(output)


func OnRegisterButtonPressed():

	if not (client.lastState == WebSocketPeer.STATE_OPEN):
		signIinErrorMessageLabel.text = 'Error connecting to server please try again.'
		return

	var email = emailInput.text
	var password = passwordInput.text

	if not (email and password):
		signIinErrorMessageLabel.text = "Email and password are required"
		return

	var data = {
		email = email,
		password = password
	}

	var output = WSSendMessage.new("authentication", "signup", data).stringify()

	client.Send(output)


func OnClientReceivedMessage(message):
	print(message)

func OnConnectionClosed():
	print("client closed")