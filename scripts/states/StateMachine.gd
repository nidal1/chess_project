class_name StateMachine

extends Node

@export var initialState = NodePath()
@onready var currentState: StateBase = get_node(initialState)

@export var gameUI: GameUI
@export var gameRules: GameRule

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.stateMachine = self
		# child.showInfo()
		
	currentState.enter(null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	currentState.update(delta)
	
func switchTo(targetState: String, data = null):
	if not has_node(targetState):
		print("could not find the target state node")
		return
		
	currentState.exit()
	currentState = get_node(targetState)
	currentState.enter(data)
	print("current state ", currentState)
