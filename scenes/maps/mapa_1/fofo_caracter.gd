extends CharacterBody3D

@export var movement_speed: float = 3.0
@export var wander_radius: float = 8.0
@export var idle_time: float = 7.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $fofo/AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var attack: AudioStreamPlayer3D = $fofo/fofo_attack

var target_position: Vector3
var is_waiting: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	# Define o primeiro destino assim que começar
	is_waiting=true
	await GlobalSettings.acabou_cutscene
	is_waiting=false
	_select_new_random_target()

func _physics_process(delta):
	if is_waiting:
		return

	if nav_agent.is_navigation_finished():
		_start_idle_timer()
		return

	# Calcula a próxima posição no caminho
	var next_path_pos = nav_agent.get_next_path_position()
	var current_pos = global_position
	
	# Direção e Movimentação
	var new_velocity = (next_path_pos - current_pos).normalized() * movement_speed
	velocity = new_velocity
	
	# Rotaciona o inimigo para olhar para onde está indo (suavemente)
	if velocity.length() > 0.1:
		var look_target = Vector3(next_path_pos.x, global_position.y, next_path_pos.z)
		look_at(look_target, Vector3.UP)
		rotate_y(PI) # Ajuste se o modelo estiver de costas

	# Aplica gravidade se não estiver no chão
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = -0.1 # Uma pequena força para baixo para manter o contato

	move_and_slide()

func _select_new_random_target():
	#volta a andar
	playback.travel("walk")
	
	# Gera um ponto aleatório dentro de um círculo no plano XZ
	var random_direction = Vector3(
		randf_range(-1, 1),
		0,
		randf_range(-1, 1)
	).normalized()
	
	target_position = global_position + (random_direction * wander_radius)
	
	# Define o alvo no NavigationAgent
	nav_agent.target_position = target_position

func _start_idle_timer():
	
	#faz o movimento crazy
	playback.travel("funny")
	attack.play()
	
	is_waiting = true
	velocity = Vector3.ZERO
	# Cria um timer temporário para esperar antes de andar de novo
	await get_tree().create_timer(idle_time).timeout

	is_waiting = false
	_select_new_random_target()

func _on_timer_timeout() -> void:
	pass # Replace with function body.


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	playback.travel("talk")
