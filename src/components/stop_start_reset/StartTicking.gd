extends Button


func _ready() -> void:
	disabled = TickSystem.IsTicking()
	TickSystem.toggled.connect(set_disabled)
	pressed.connect(_OnPressed)


func _OnPressed() -> void:
	TickSystem.Start()
