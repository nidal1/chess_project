extends Node

var matchId: String

var playerDictionary: Dictionary = {
	"username": "",
	"info": null,
	"role": null,
	"score": null,
}

var opponentDictionary: Dictionary = {
	"username": "",
	"info": null,
	"role": null,
	"score": null,
}

func reset():
	matchId = ""
	playerDictionary = {"username": "", "info": null, "role": null, "score": null}
	opponentDictionary = {"username": "", "info": null, "role": null, "score": null}