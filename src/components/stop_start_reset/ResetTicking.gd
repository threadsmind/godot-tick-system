extends Button


func _ready() -> void:
	pressed.connect(_OnPressed)


func _OnPressed() -> void:
	TickSystem.Reset()
