extends Node2D
@onready var play: Button = $Control/VBoxContainer/play
@onready var fofo_frase_1: AudioStreamPlayer3D = $cena_1/fofo/frase_1
@onready var eu_frase_1: AudioStreamPlayer3D = $cena_1/eu/frase_1
@onready var eu_frase_2: AudioStreamPlayer3D = $cena_1/eu/frase_2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/mapa_1/mapa_1_test_2.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
