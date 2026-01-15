class_name PipeDisplay
extends Control


signal pressed

@export var _leftInputDisplay: Control
@export var _rightInputDisplay: Control
@export var _ltrButton: Button


func _ready() -> void:
	_rightInputDisplay.set_visible(false)
	_ltrButton.pressed.connect(pressed.emit)


func SetLeftToRight(isLtr: bool) -> void:
	_rightInputDisplay.set_visible(!isLtr)
	_leftInputDisplay.set_visible(isLtr)
	_ltrButton.text = ">" if isLtr else "<"
