extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_first_node_in_group("camera_player").make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
