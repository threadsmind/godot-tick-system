extends Label


@export var _nthTick: int

var _tickCount: int


func _ready() -> void:
	TickSystem.ticked.connect(_OnTick)
	TickSystem.reset.connect(_OnReset)
	_nthTick = maxi(absi(_nthTick), 1)
	text = "0"


func _OnTick(tick: int) -> void:
	if tick % _nthTick != 0: return
	_tickCount += 1
	text = str(_tickCount)


func _OnReset() -> void:
	_tickCount = 0
	text = "0"
