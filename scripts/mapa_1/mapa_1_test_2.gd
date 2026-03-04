extends Node3D
@onready var camera_cena_1: Camera3D = $cena_1/camera_cena_1
@onready var camera_cena_3: Camera3D = $cena_1/camera_cena_3
@onready var camera_cena_2: Camera3D = $cena_1/camera_cena_2
@onready var camera_cena_4: Camera3D = $cena_1/camera_cena_4
@onready var eu_frase_1: AudioStreamPlayer3D = $cena_1/eu_caracter/eu/frase_1
@onready var eu_frase_2: AudioStreamPlayer3D = $cena_1/eu_caracter/eu/frase_2
@onready var fofo_frase_1: AudioStreamPlayer3D = $cena_1/fofo_caracter/fofo/frase_1
@onready var camera_3d: Camera3D = $Lady/CharacterBody3D/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#return
	GlobalSettings.in_cutscene = true
	camera_cena_3.make_current()
	
	await get_tree().create_timer(2.0).timeout
	fofo_frase_1.play()
	camera_cena_4.make_current()
	
	await get_tree().create_timer(4.0).timeout
	camera_cena_3.make_current()
	eu_frase_1.play()
	
	await get_tree().create_timer(4.0).timeout
	camera_cena_1.make_current()
	
	await get_tree().create_timer(4.0).timeout
	camera_cena_4.make_current()
	
	await get_tree().create_timer(2.0).timeout
	camera_cena_1.make_current()
	
	await get_tree().create_timer(3.0).timeout
	camera_cena_2.make_current()
	eu_frase_2.play()

	await get_tree().create_timer(2.0).timeout
	camera_3d.make_current()
	GlobalSettings.in_cutscene = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
