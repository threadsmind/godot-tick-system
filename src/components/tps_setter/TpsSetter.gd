extends TextEdit


var _filterRegEx: String = "[0-9]+"
var _textFilter: RegEx
var _lastCleanText: String
var _debounceTimer: SceneTreeTimer
var _debounceLength: float = 1


func _ready() -> void:
	text = str(TickSystem.targetTPS)
	_lastCleanText = text
	_textFilter = RegEx.new()
	_textFilter.compile(_filterRegEx)
	text_changed.connect(_OnTextChanged)
	TickSystem.tps_updated.connect(_OnTPSUpdated)


func _OnTextChanged() -> void:
	# filter non-numeric input
	var textAsInput: String = text
	var results: Array[RegExMatch] = _textFilter.search_all(textAsInput)
	var filteredText: String = ""
	for result: RegExMatch in results:
		filteredText = "%s%s" % [filteredText, result.get_string()]
	var textAsInt: int = int(filteredText)
	var filteredInt: int = mini(textAsInt, 9999)
	# cache previous caret location
	var caretLocation: int = get_caret_column()
	var intAsText: String = str(filteredInt) if (
		filteredInt != 0 and text != "0"
	) else ""
	text = intAsText
	# place the caret where it should be after setting the filtered text
	var caretModifier: int = 0 if textAsInput == text else -1
	var adjustedCaretLocation: int = caretLocation + caretModifier
	set_caret_column(adjustedCaretLocation)
	_lastCleanText = text
	_DebounceSubmit()


func _DebounceSubmit() -> void:
	if _debounceTimer != null:
		_debounceTimer.timeout.disconnect(_OnSubmit)
	_debounceTimer = get_tree().create_timer(_debounceLength)
	_debounceTimer.timeout.connect(_OnSubmit)


func _OnSubmit() -> void:
	TickSystem.targetTPS = int(text)


func _OnTPSUpdated(tps: int) -> void:
	# reconcile tps text if tps is changed elsewhere
	var tpsString: String = str(tps)
	if tpsString != text: text = tpsString
