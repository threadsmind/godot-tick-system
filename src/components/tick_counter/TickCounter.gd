extends Label


func _ready() -> void:
	TickSystem.ticked.connect(_OnTick)
	TickSystem.reset.connect(_OnReset)


func _OnTick(tick: int) -> void:
	text = str(tick)


func  _OnReset() -> void:
	text = "0"
