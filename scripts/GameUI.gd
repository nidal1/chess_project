extends Node3D

class_name GameUI

@onready var whiteScoreLabel: Label = $HBoxContainer/WhiteScore
@onready var blackScoreLabel: Label = $HBoxContainer2/BlackScore
@onready var playerRoleLabel: Label = $PlayerRole
@onready var passantPanel: Panel = $PassantPanel
@onready var blackHPassantContainer: HBoxContainer = $PassantPanel/BlackHBoxContainer
@onready var whiteHPassantContainer: HBoxContainer = $PassantPanel/WhiteHBoxContainer

func InitScoreLabels(_blackScore, _whiteScore):
	blackScoreLabel.text = str(_blackScore)
	whiteScoreLabel.text = str(_whiteScore)

func UpdateWhiteScore(score: int) -> void:
	# Update the white score label
	var prevScore = int(whiteScoreLabel.text)
	whiteScoreLabel.text = str(prevScore - score)

func UpdateBlackScore(score: int) -> void:
	# Update the black score label
	var prevScore = int(blackScoreLabel.text)
	blackScoreLabel.text = str(prevScore - score)

func UpdatePlayerRole(role: String) -> void:
	# Update the player role label
	playerRoleLabel.text = role + "'s role"
	pass


func ToggleBlackHPassantContainer():
	if blackHPassantContainer.visible == true:
		passantPanel.visible = false
		blackHPassantContainer.visible = false
		return
	passantPanel.visible = true
	blackHPassantContainer.visible = true

func ToggleWhiteHPassantContainer():
	if whiteHPassantContainer.visible == true:
		passantPanel.visible = false
		whiteHPassantContainer.visible = false
		return
	passantPanel.visible = true
	whiteHPassantContainer.visible = true

	# Connect signals or perform other setup if needed


func _ready():
	print("from game ui")


