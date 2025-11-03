class_name WSResponse
extends Node


var service: String
var operation: String
var data: Variant = null
var error: String = ""

func _init(message: String):
	var json = JSON.parse_string(message)
	self.service = json["service"]
	self.operation = json["operation"]
	
	if self.service == 'error':
		self.error = json["error"]
		return
	if json.get("data"):
		self.data = json["data"]
