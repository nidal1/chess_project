extends Node

# Stores the currently loaded scene
var current_scene: Node = null

# Preload your scenes (optional but recommended for efficiency)
var lobby = preload("res://scenes/lobby.tscn").instantiate()
var chessBoard = preload("res://scenes/ChessBoard.tscn").instantiate()

func _ready():
	# Load the first scene when the game starts
	change_scene(lobby)

# Function to change the scene
func change_scene(new_scene: Node):
	if current_scene != null:
		# Remove the current scene from the tree
		current_scene.queue_free()

	# Instance the new scene
	current_scene = new_scene

	# Add the new scene to the current scene tree
	add_child(current_scene)

func switch_scene():
	if current_scene == null:
		return
	current_scene.queue_free()
	if current_scene == lobby:
		current_scene.queue_free()

		current_scene = chessBoard

	else:
		current_scene.queue_free()

		current_scene = lobby

	add_child(current_scene)

# Function to load a scene by its path
func change_scene_by_path(scene_path: String):
	var new_scene = load(scene_path)
	if new_scene:
		change_scene(new_scene)

# Example function to reload the current scene
func reload_scene():
	if current_scene:
		change_scene(current_scene.instantiate())
