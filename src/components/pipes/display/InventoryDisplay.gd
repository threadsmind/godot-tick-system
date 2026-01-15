class_name InventoryDisplay
extends Control


@export var _itemCountLabel: Label

func SetItemCount(count: int) -> void:
	_itemCountLabel.text = str(count)
