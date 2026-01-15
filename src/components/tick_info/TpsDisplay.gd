extends Label


func _ready() -> void:
	text = str(TickSystem.targetTPS)
	TickSystem.tps_updated.connect(_OnTpsUpdated)


func _OnTpsUpdated(tps: int) -> void:
	text = str(tps)
