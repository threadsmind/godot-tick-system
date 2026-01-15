extends Label


func _ready() -> void:
	text = str(Engine.physics_ticks_per_second)
