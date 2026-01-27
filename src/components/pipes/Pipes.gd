extends Control


@export var _inventoryDisplayA: InventoryDisplay
@export var _inventoryDisplayB: InventoryDisplay
@export var _pipeDisplay: PipeDisplay

var _pipe: Pipe = Pipe.new(5, 5)
var _inventoryA: Inventory = Inventory.new(100)
var _inventoryB: Inventory = Inventory.new(0)


class Pipe:
	signal reversed(isLtr: bool)
	
	var _tickFrequency: int
	var _bandwidthPerTick: int
	var _buffer: int
	var _isLeftToRight: bool = true
	var _connectedInventories: Array[Inventory]
	
	func _init(_frequency: int, _bandwidth: int) -> void:
		_tickFrequency = _frequency
		_bandwidthPerTick = _bandwidth
	
	func ConnectInventories(input: Inventory, output: Inventory) -> void:
		_connectedInventories = [input, output]
	
	func ReverseDirection() -> void:
		_connectedInventories.reverse()
		_isLeftToRight = !_isLeftToRight
		reversed.emit(_isLeftToRight)
	
	func OnTick(tick: int) -> void:
		if tick % _tickFrequency != 0: return
		_PullFrom(_connectedInventories[0])
		_PushTo(_connectedInventories[1])
	
	func OnReset() -> void:
		if _isLeftToRight: return
		ReverseDirection()
	
	func _PullFrom(inv: Inventory) -> void:
		if inv.itemCount == 0: return
		_buffer = inv.itemCount - inv.ModifyItemCount(-_bandwidthPerTick)
	
	func _PushTo(inv: Inventory) -> void:
		if _buffer == 0: return
		inv.ModifyItemCount(_buffer)
		_buffer = 0


class Inventory:
	signal count_updated(count: int)
	
	var itemCount: int:
		set(value):
			itemCount = value
			count_updated.emit(itemCount)
	
	func _init(_count: int) -> void:
		itemCount = _count
	
	func ModifyItemCount(delta: int) -> int:
		itemCount = maxi(itemCount + delta, 0)
		return itemCount


func _ready() -> void:
	TickSystem.ticked.connect(_pipe.OnTick)
	TickSystem.reset.connect(_OnReset)
	TickSystem.reset.connect(_pipe.OnReset)
	_inventoryA.count_updated.connect(_inventoryDisplayA.SetItemCount)
	_inventoryB.count_updated.connect(_inventoryDisplayB.SetItemCount)
	_pipeDisplay.pressed.connect(_pipe.ReverseDirection)
	_pipe.reversed.connect(_pipeDisplay.SetLeftToRight)
	_pipe.ConnectInventories(_inventoryA, _inventoryB)


func _OnReset() -> void:
	_inventoryA.itemCount = 100
	_inventoryB.itemCount = 0
