class_name WSSendMessage

var event: String
var data: Variant = null


func _init(_event: String, _data: Variant):
	self.event = _event
	self.data = _data

func stringify():
	var output = {
		event = self.event,
		data = self.data
	}
	return JSON.stringify(output)