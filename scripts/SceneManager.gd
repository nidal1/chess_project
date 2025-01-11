extends Node

# Stores the currently loaded scene
var current_scene: Node = null

@export var lobbyResource: Resource
@export var chessBoardResource: Resource
@export var authenticationResource: Resource

var lobby
var chessBoard
var authenticationScene

enum SCENES {
	LOBBY,
	CHESSBOARD,
	AUTHENTICATION,
}


func _ready():
	lobby = lobbyResource.instantiate()
	chessBoard = chessBoardResource.instantiate()
	authenticationScene = authenticationResource.instantiate()
	# Load the first scene when the game starts
	change_scene(SCENES.AUTHENTICATION)

# Function to change the scene
func change_scene(new_scene: SCENES):
	if current_scene != null:
		# Remove the current scene from the tree
		current_scene.queue_free()


	match new_scene:
		SCENES.LOBBY:
			current_scene = lobby
		SCENES.CHESSBOARD:
			current_scene = chessBoard
		SCENES.AUTHENTICATION:
			current_scene = authenticationScene
		_:
			current_scene = authenticationScene

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
