extends Node3D

class_name GameUI

@onready var whiteScoreLabel: Label = $HBoxContainer/WhiteScore
@onready var blackScoreLabel: Label = $HBoxContainer2/BlackScore
@onready var playerRoleLabel: Label = $PlayerRole
@onready var passantPanel: Panel = $PassantPanel
@onready var blackHPassantContainer: HBoxContainer = $PassantPanel/BlackHBoxContainer
@onready var whiteHPassantContainer: HBoxContainer = $PassantPanel/WhiteHBoxContainer
@onready var checkContainer: HBoxContainer = %HBoxContainer3

var visibleHighlightCircles: Array[ChessSquare] = []
var visibleHighlightArrows: Array[ChessSquare] = []

func InitScoreLabels(_blackScore, _whiteScore):
	blackScoreLabel.text = str(_blackScore)
	whiteScoreLabel.text = str(_whiteScore)

func UpdateWhiteScore(score: int) -> void:
	# Update the white score label
	var prevScore = int(whiteScoreLabel.text)
	whiteScoreLabel.text = str(score)

func UpdateBlackScore(score: int) -> void:
	# Update the black score label
	var prevScore = int(blackScoreLabel.text)
	blackScoreLabel.text = str(score)

func UpdatePlayerRole(role: String) -> void:
	# Update the player role label
	playerRoleLabel.text = role + "'s role"
	pass

func ToggleCheckContainer() -> void:
	if checkContainer.visible == true:
		checkContainer.visible = false
		return
	checkContainer.visible = true

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

func ToggleShowHighlightCircles(_visible) -> void:
	if visibleHighlightCircles.size() > 0:
		for square in visibleHighlightCircles:
			square.ToggleVisualCircleVisibility(_visible)

func ClearHighlightCircles(selectedSquare) -> void:
	ToggleShowHighlightCircles(false)
	visibleHighlightCircles.clear()
	selectedSquare = null

func ToggleShowHighlightArrows(_visible) -> void:
	if visibleHighlightArrows.size() > 0:
		for square in visibleHighlightArrows:
			square.ToggleVisualDownArrowVisibility(_visible)

func ClearHighlightArrows() -> void:
	ToggleShowHighlightArrows(false)
	visibleHighlightArrows.clear()
