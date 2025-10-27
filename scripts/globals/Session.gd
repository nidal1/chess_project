extends Node

var matchId: String

var playerDictionary: Dictionary = {
	"info": null,
	"role": null,
	"score": null,
}

var opponentDictionary: Dictionary = {
	"info": null,
	"role": null,
	"score": null,
}

func reset():
	matchId = ""
	playerDictionary = {"info": null, "role": null, "score": null}
	opponentDictionary = {"info": null, "role": null, "score": null}