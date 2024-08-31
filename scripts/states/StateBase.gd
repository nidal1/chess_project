class_name StateBase

extends Node

@onready var client: WSClient = get_node("/root/SceneManager/WSC")

var stateMachine: StateMachine


func enter(data = null):
	if not client.connection_closed.is_connected(OnWebSocketConnectionClosed):
		client.SetConnectionClosedToServerCallback(OnWebSocketConnectionClosed)
	
	if not client.message_received.is_connected(OnWebSocketMessageReceived):
		client.SetMessageReceivedFromTheServerCallback(OnWebSocketMessageReceived)
	pass


func OnWebSocketConnectionClosed():
	var ws = client.GetSocket()
	print("Disconnected from server with code %s and reason %s" % [ws.get_close_code(), ws.get_close_reason()])
	pass

func OnWebSocketMessageReceived(message):
	print("Message received : %s" % [message])
	pass


func exit():
	print("exiting state: ", name)
	pass
	
func update(_delta: float):
	pass

func showInfo():
	print(name, "/", stateMachine)
