class_name FlowBox
extends PanelContainer


# reparent any scene children under the subcontainer
func _ready() -> void:
	var children: Array[Node] = get_children()
	if children.size() <= 1: return
	for child: Node in children:
		if child == children[0]: continue
		child.reparent(children[0])
