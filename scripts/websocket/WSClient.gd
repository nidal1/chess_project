extends Node

class_name WSClient

var socket := WebSocketPeer.new()
var _last_state = WebSocketPeer.STATE_CLOSED

signal connecting()
signal connected_to_server()
signal connection_closed()
signal message_received(message: Variant)

func Poll():
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()

	var state = socket.get_ready_state()

	if _last_state != state:
		_last_state = state

		if state == socket.STATE_CONNECTING:
			connecting.emit()
		elif state == socket.STATE_OPEN:
			connected_to_server.emit()
		elif state == socket.STATE_CLOSED:
			connection_closed.emit()
			set_process(false)
	
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count():
		message_received.emit(_get_message())

func Send(message) -> int:
	if typeof(message) == TYPE_STRING:
		return socket.send_text(message)

	return socket.send(var_to_bytes(message))

func ConnectToURL(url: String) -> int:
	var error = socket.connect_to_url(url)
	if error != OK:
		return error

	_last_state = socket.get_ready_state()
	set_process(true)
	return OK

func _get_message() -> Variant:
	if socket.get_available_packet_count() < 1:
		return null

	var packet = socket.get_packet()
	if socket.was_string_packet():
		return packet.get_string_from_utf8()

	return bytes_to_var(packet)

func Close(code := 1000, reason = ""):
	socket.close(code, reason)
	_last_state = socket.get_ready_state()

func Clear():
	# This function is empty. Consider adding logic to reset the client
	# or remove it if it's not needed.
	print("WSClient cleared")

func GetSocket() -> WebSocketPeer:
	return socket


func _process(delta):
	Poll()
