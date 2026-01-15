extends GridContainer


# Inspired by Minecraft's random tick system for block updates.
#	https://minecraft.fandom.com/wiki/Tick#Random_tick
var _randomTickSpeed: int = 3

var _childCount: int = 31
var _colors: ColorCombo = ColorCombo.new(
	Color.WHITE,
	Color.DEEP_PINK
)
var _panelScene: PackedScene = preload("uid://dbcwhpqej6hxh")


func _ready() -> void:
	TickSystem.ticked.connect(_OnTick)
	_BuildPanelArray()


func _OnTick(_tick: int) -> void:
	for _ticked: int in _randomTickSpeed:
		var tickedIndex: int = randi_range(0, _childCount)
		var child: Control = get_child(tickedIndex) as Control
		_ColorShift(child)


func _ColorShift(node: Control) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate", _colors.secondary, 0.05)
	tween.finished.connect(_ColorReset.bind(node))


func _ColorReset(node: Control) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate", _colors.primary, 0.2)


func _BuildPanelArray() -> void:
	for _index in _childCount:
		var panel: Node = _panelScene.instantiate()
		add_child(panel)
