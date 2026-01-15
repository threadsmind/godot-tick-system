## A framerate-independent game tick system based on Godot's physics processing loop.
##
## [b]TickSystem[/b] is a wrapper for Godot's physics processing loop. It provides
##	ways to control and access a framerate-independent game tick loop separately from
##	Godot's physics loop.
## [br][br]
## [b]Example:[/b] Set the target TPS to a non-default value, connect a method
##	that will be called on each game tick, then begin the tick loop:
## [codeblock]
## func _ready():
##    TickSystem.targetTPS = 10  # [default 20]
##    TickSystem.ticked.connect(_on_tick)
##    TickSystem.Start()
##
## func _on_tick(_ticks):
##     print("Tick!")
## [/codeblock]
## [br][br]
## [b]Note:[/b] Ticks per second (TPS) for this system is limited to the range of
##	[code]1[/code] to [code]Engine.physics_ticks_per_second[/code]. If your use
##	case requires less frequent ticks (longer than 1 second), you can use a modulo
##	operation on the tick accumulation value passed in the `ticked` signal where
##	the modulus is greater than the system's current TPS.
## [br][br]
## [b]Note:[/b] While starting, stopping, or changing the TPS of the TickSystem does
##	not affect Godot's physics loop, changes to [member Engine.physics_ticks_per_second]
##	[b]will[/b] affect the speed of the TickSystem loop.
extends Node


## Emitted when a tick occurs. The total tick count is passed in the
##	[param accumulator] argument.
signal ticked(accumulator: int)
## Emitted when the target ticks per second value ([member targetTPS]) is modified.
signal tps_updated(tps: int)
## Emitted when the tick system is reset (see [method Reset]).
signal reset
## Emitted when the tick system is started or stopped. The active state is passed
##	in the [param isTicking] argument.
signal toggled(isTicking: bool)

## The amount of ticks per second ranging from a minimum of [code]1[/code] to a
##	maximum of [member Engine.physics_ticks_per_second]. Emits [signal tps_updated]
##	when the value is changed.
var targetTPS: int = 20:
	set(value):
		if value > Engine.physics_ticks_per_second:
			push_warning("TPS cannot be greater than physics ticks.")
			value = Engine.physics_ticks_per_second
		if value <= 0:
			push_warning("TPS must be a positive, non-zero integer.")
			value = 1
		if value == targetTPS: return
		targetTPS = value
		tps_updated.emit(value)

var _tickCount: int
var _physicsTicksPerTick: int


func _ready() -> void:
	# tick system begins disabled by default
	_SetTicking(false, false)
	
	_RecalculatePhysicsTicksPerGameTick(targetTPS)
	tps_updated.connect(_RecalculatePhysicsTicksPerGameTick)


## Begins the accumulation of ticks.
func Start() -> void:
	_SetTicking(true)


## Pauses the accumulation of ticks.
func Pause() -> void:
	_SetTicking(false)


## Stops and resets the accumulation of ticks. Both the [signal reset] and
##	[signal toggled] signals are fired when resetting the system.
func Reset() -> void:
	_SetTicking(false)
	_tickCount = 0
	reset.emit()


## Returns whether or not the tick system is currently active.
func IsTicking() -> bool:
	return is_physics_processing()


func _SetTicking(on: bool, doEmit: bool = true) -> void:
	set_physics_process(on)
	if doEmit: toggled.emit(on)


func _RecalculatePhysicsTicksPerGameTick(tps: int) -> void:
	_physicsTicksPerTick = int(Engine.physics_ticks_per_second / float(tps))


func _physics_process(_delta: float) -> void:
	if Engine.get_physics_frames() % _physicsTicksPerTick != 0: return
	_tickCount += 1
	ticked.emit(_tickCount)
