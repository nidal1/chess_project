extends Node

class_name WSClient

var socket := WebSocketPeer.new()
var lastState = WebSocketPeer.STATE_CLOSED
var matchId: String

signal connecting()
signal connected_to_server()
signal connection_closed()
signal message_received(message: Variant)

func SetConnectedToServerCallback(callback):
	connected_to_server.connect(callback)

func SetConnectionClosedToServerCallback(callback):
	connection_closed.connect(callback)

func SetMessageReceivedFromTheServerCallback(callback):
	message_received.connect(callback)

func SetDisconnectedToServerCallback(callback):
	connected_to_server.disconnect(callback)

func SetDisconnectionClosedToServerCallback(callback):
	connection_closed.disconnect(callback)

func SetDisconnectedMessageReceivedFromTheServerCallback(callback):
	message_received.disconnect(callback)

func Poll():
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()

	var state = socket.get_ready_state()

	if lastState != state:
		lastState = state

		if state == socket.STATE_CONNECTING:
			connecting.emit()
		elif state == socket.STATE_OPEN:
			connected_to_server.emit()
		elif state == socket.STATE_CLOSED:
			connection_closed.emit()
	
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count():
		message_received.emit(GetMessage())

func Send(message) -> int:
	if typeof(message) == TYPE_STRING:
		return socket.send_text(message)

	return socket.send(var_to_bytes(message))

func ConnectToURL(url: String) -> int:
	var error = socket.connect_to_url(url)
	if error != OK:
		return error

	lastState = socket.get_ready_state()
	return OK

func GetMessage() -> Variant:
	if socket.get_available_packet_count() < 1:
		return null

	var packet = socket.get_packet()
	if socket.was_string_packet():
		return packet.get_string_from_utf8()

	return bytes_to_var(packet)

func Close(code := 1000, reason = ""):
	socket.close(code, reason)
	lastState = socket.get_ready_state()

func Clear():
	print("clear")

func GetSocket() -> WebSocketPeer:
	return socket


func _process(delta):
	Poll()