extends CharacterBody3D

const SPEED = 2.0 # Velocidade de patrulha mais lenta que o jogador
const WANDER_RANGE = 10.0 # O quão longe ele pode ir

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var timer: Timer = $Timer
@onready var visual_node = $eu

func _ready() -> void:
	# Espera um frame para o NavMesh carregar
	call_deferred("setup_target")

func setup_target() -> void:
	# Escolhe um ponto aleatório apenas no eixo Z (plataforma lateral)
	var random_z = global_position.z + randf_range(-WANDER_RANGE, WANDER_RANGE)
	var target_pos = Vector3(global_position.x, global_position.y, random_z)
	
	nav_agent.target_position = target_pos

func _physics_process(delta: float) -> void:
	# 1. Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Navegação
	if nav_agent.is_navigation_finished():
		if timer.is_stopped():
			timer.start(randf_range(1.0, 3.0)) # Espera entre 1 e 3 segundos
		return

	# Calcula a direção para o próximo ponto do NavMesh
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	
	# Forçamos a direção a ser apenas no eixo Z para manter o estilo plataforma
	direction.x = 0 
	
	if direction:
		velocity.z = direction.z * SPEED
		
		# Lógica de virar o visual
		var target_rotation = 0.0 if direction.z > 0 else PI
		if visual_node:
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, target_rotation, 0.1)
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# 3. Trava o eixo X (como no player)
	velocity.x = 0
	rotation.y = 0
	
	move_and_slide()

# Quando o tempo de espera acaba, escolhe um novo destino
func _on_timer_timeout() -> void:
	setup_target()
