extends Node


# how many game ticks do we want per second
@export var _targetTps: float = 20

@export_category("UI")
# we're using exports because it's all one scene and strings are 🤮
@export var _labelPhysicsTicks: Label
@export var _labelFullTicks: Label
@export var _labelLongTicks: Label
@export var _labelVeryLongTicks: Label
@export var _labelSecondsTicks: Label

@export var _desyncWarn: Label

@export var _labelTargetTps: Label
@export var _labelTargetPhysicsTps: Label

var _totalTicks: int = 0
var _totalLongTicks: int = 0
var _totalVeryLongTicks: int = 0
var _totalSecondsTicks: int = 0

# calculate some tick (sub)intervals based on the engine's configured physics tps
var _physicsTicks: int = Engine.physics_ticks_per_second
var _physicsTicksPerTick: int = int(_physicsTicks / _targetTps)
var _physicsTicksPerLongTick: int = int(_physicsTicks / (_targetTps / 2))
var _physicsTicksPerVeryLongTick: int = int(_physicsTicks / (_targetTps / 4))


func _ready() -> void:
	_labelTargetTps.text = str(int(_targetTps))
	_labelTargetPhysicsTps.text = str(_physicsTicks)


func _OnTick() -> void:
	_totalTicks += 1
	_labelFullTicks.text = str(_totalTicks)


func _OnLongTick() -> void:
	_totalLongTicks += 1
	_labelLongTicks.text = str(_totalLongTicks)


func _OnVeryLongTick() -> void:
	_totalVeryLongTicks += 1
	_labelVeryLongTicks.text = str(_totalVeryLongTicks)


func _OnSecondsTick(delta: float) -> void:
	_totalSecondsTicks += 1
	_labelSecondsTicks.text = str(_totalSecondsTicks)
	# check delta against its theoretical formula (see _physics_process() docs)
	# realistically, you should not ever see this when running this demo scene alone
	var isDesynced: bool = Engine.time_scale / Engine.physics_ticks_per_second != delta
	_desyncWarn.text = "Desync: %s" % delta if isDesynced else ""


func _physics_process(delta: float) -> void:
	# cache physics frame count
	var physicsFrames: int = Engine.get_physics_frames()
	_labelPhysicsTicks.text = str(physicsFrames)
	# check tick intervals agains the current physics frame count
	if physicsFrames % _physicsTicksPerTick == 0:
		_OnTick()
	if physicsFrames % _physicsTicksPerLongTick == 0:
		_OnLongTick()
	if physicsFrames % _physicsTicksPerVeryLongTick == 0:
		_OnVeryLongTick()
	if physicsFrames % _physicsTicks == 0:
		_OnSecondsTick(delta)
