extends Control


@export var _progressBar: ProgressBar
@export var _pointsDisplay: Control
@export var _pointsValue: Label

var _points: int


func _ready() -> void:
	TickSystem.ticked.connect(_OnTick)
	TickSystem.reset.connect(_OnReset)


func _OnTick(_tick: int) -> void:
	_progressBar.value += 1
	if is_equal_approx(_progressBar.value, _progressBar.max_value):
		_progressBar.value = 0
		_OnGainPoints()


func _OnReset() -> void:
	_progressBar.value = 0
	_points = 0


func _OnGainPoints() -> void:
	_points += 1
	_pointsValue.text = str(_points)
	if _pointsDisplay.visible == false:
		_pointsDisplay.set_visible(true)
