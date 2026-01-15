extends Control


@export var _button: Button
@export var _label: Label

var _delayTicks: int = 22
var _currentDelayTicks: int

var _isDelaying: bool
var _colors: ColorCombo = ColorCombo.new(
	Color("ffffffff"),
	Color("ffffff00")
)


func _ready() -> void:
	TickSystem.toggled.connect(_OnPause)
	TickSystem.reset.connect(_OnReset)
	_button.pressed.connect(_OnPressed)


func _OnPressed() -> void:
	if _isDelaying: return
	_isDelaying = true
	_button.set_disabled(true)
	TickSystem.ticked.connect(_OnTick)


func _OnTick(_tick: int) -> void:
	_currentDelayTicks += 1
	if _currentDelayTicks == _delayTicks:
		_OnDelayComplete()


func _OnPause(isActive: bool) -> void:
	_button.set_disabled(not isActive or _isDelaying)


func _OnReset() -> void:
	if _isDelaying:
		TickSystem.ticked.disconnect(_OnTick)
	_isDelaying = false
	_currentDelayTicks = 0


func _OnDelayComplete() -> void:
	TickSystem.ticked.disconnect(_OnTick)
	_currentDelayTicks = 0
	_isDelaying = false
	_button.set_disabled(false)
	_ShowMessage()


func _ShowMessage() -> void:
	_label.modulate = _colors.secondary
	var tween: Tween = create_tween()
	tween.tween_property(_label, "modulate", _colors.primary, 0.05)
	tween.finished.connect(_HideMessage)


func _HideMessage() -> void:
	await get_tree().create_timer(0.6).timeout
	var tween: Tween = create_tween()
	tween.tween_property(_label, "modulate", _colors.secondary, 0.25)
