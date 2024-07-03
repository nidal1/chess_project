class_name CheckState

var constants = preload("res://scripts/Constants.gd")

enum CheckEnum{
    CHECK,
    NOTCHECK
}

var state  = {"checkState": CheckEnum.NOTCHECK, "role": null}

func Actions():
	return {
		"setToNull": {
			"checkState": CheckEnum.NOTCHECK,
			"role": null
		},
		"setToCheck": null
	}

func UpdateState(newState, role):
	match newState:
		CheckEnum.NOTCHECK:
			state.checkState = newState
			state.role = role
		CheckEnum.CHECK:
			state = newState

