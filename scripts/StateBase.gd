class_name StateBase

extends Node

var stateMachine: StateMachine

func enter(data=null):
	print("entering state: ", name)
	pass

func exit():
	print("exiting state: ", name)
	pass
	
func update(_delta: float):
	pass

func showInfo():
	print(name, "/", stateMachine)
