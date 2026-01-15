extends Control


@export var _progressBar: ProgressBar
@export var _messageLabel: Label

var _damageValue: int = 2
var _damageFrequency: int = 15
var _respawnDelay: int = 2

var _currentRespawnTimer: int

var _goodColorCombo: ColorCombo = ColorCombo.new(
	Color("26af00ff"),
	Color("26af0000")
)
var _badColorCombo: ColorCombo = ColorCombo.new(
	Color("ff6050ff"),
	Color("ff605000")
)


func _ready() -> void:
	TickSystem.ticked.connect(_OnTick)
	TickSystem.reset.connect(_OnReset)


func _OnTick(tick: int) -> void:
	if tick % _damageFrequency != 0: return
	if _progressBar.value <= 0:
		_RespawnTick()
		return
	_progressBar.value -= _damageValue
	_ShowMessage("-%s HP" % _damageValue)


func _OnReset() -> void:
	_currentRespawnTimer = 0
	_progressBar.value = _progressBar.max_value


func _ResetHealthBar() -> void:
	_progressBar.value = _progressBar.max_value
	_ShowMessage("Respawn!", _goodColorCombo)


func _RespawnTick() -> void:
	_currentRespawnTimer += 1
	if _currentRespawnTimer != _respawnDelay: return
	_currentRespawnTimer = 0
	_ResetHealthBar()


func _ShowMessage(message: String, colors: ColorCombo = _badColorCombo) -> void:
	_messageLabel.text = message
	_messageLabel.modulate = colors.secondary
	var tween: Tween = create_tween()
	tween.tween_property(_messageLabel, "modulate", colors.primary, 0.05)
	tween.finished.connect(_HideMessage.bind(colors))


func _HideMessage(colors: ColorCombo) -> void:
	await get_tree().create_timer(0.25).timeout
	var tween: Tween = create_tween()
	tween.tween_property(_messageLabel, "modulate", colors.secondary, 0.2)
