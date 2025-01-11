class_name WSSendMessage

var service: String
var type: String
var data: Variant = null


func _init(_service: String, _type: String, _data: Variant):
	self.service = _service
	self.type = _type
	self.data = _data

func stringify():
	var output = {
		operation = {
			service = service,
			type = type,
			data = data
		}
	}
	return JSON.stringify(output)