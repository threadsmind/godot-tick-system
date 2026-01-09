class_name CloseAppButton
extends Button


func _ready() -> void:
	pressed.connect(_OnPressed)


func _OnPressed() -> void:
	get_tree().quit()
