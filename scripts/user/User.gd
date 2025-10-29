class_name User

var displayName
var email: String
var phoneNumber
var photoURL
var uid: String

func _init(user) -> void:
	self.displayName = user["displayName"]
	self.email = user["email"]
	self.phoneNumber = user["phoneNumber"]
	self.photoURL = user["photoURL"]
	self.uid = user["uid"]

func _to_string() -> String:
	var data = '''
	- displayName:{0} 
	- email:{1}
	- phoneNumber:{2}
	- photoURL:{3}
	- uid:{4}
	'''.format([
		self.displayName,
		self.email,
		self.phoneNumber,
		self.photoURL,
		self.uid,
	])
	return data

func get_data() -> Dictionary:
	return {
		"displayName": self.displayName,
		"email": self.email,
		"phoneNumber": self.phoneNumber,
		"photoURL": self.photoURL,
		"uid": self.uid,
	}
