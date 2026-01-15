extends Button


func _ready() -> void:
	disabled = not TickSystem.IsTicking()
	TickSystem.toggled.connect(_OnToggled)
	pressed.connect(_OnPressed)


func _OnToggled(isTicking: bool) -> void:
	set_disabled(!isTicking)


func  _OnPressed() -> void:
	TickSystem.Pause()
