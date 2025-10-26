class_name User

var username
var email: String
var emailVerified: bool
var phoneNumber
var photoURL
var uid: String

func _init(user) -> void:
	self.username = user["username"]
	self.email = user["email"]
	self.emailVerified = user["emailVerified"]
	self.phoneNumber = user["phoneNumber"]
	self.photoURL = user["photoURL"]
	self.uid = user["uid"]

func _to_string() -> String:
	var data = '''
	- username:{0} 
	- email:{1}
	- emailVerified:{2}
	- phoneNumber:{3}
	- photoURL:{4}
	- uid:{5}
	'''.format([
		self.username,
		self.email,
		self.emailVerified,
		self.phoneNumber,
		self.photoURL,
		self.uid,
	])
	return data

func GetData() -> Dictionary:
	return {
		"username": self.username,
		"email": self.email,
		"emailVerified": self.emailVerified,
		"phoneNumber": self.phoneNumber,
		"photoURL": self.photoURL,
		"uid": self.uid,
	}
