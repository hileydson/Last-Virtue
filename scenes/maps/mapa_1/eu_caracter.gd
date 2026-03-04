extends CharacterBody3D

const SPEED = 1.0  # Aumentei um pouco a velocidade para o 3D livre
const WANDER_RANGE = 5.0 # Raio de alcance da caminhada aleatória

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var timer: Timer = $Timer
@onready var visual_node = $eu

func _ready() -> void:
	# Importante: O NavMesh precisa estar assado (baked) na cena
	call_deferred("setup_target")

func setup_target() -> void:
	# Escolhe um ponto aleatório em um círculo ao redor da posição atual
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var random_distance = randf_range(2.0, WANDER_RANGE)
	
	var target_pos = global_position + Vector3(random_direction.x * random_distance, 0, random_direction.y * random_distance)
	
	# O NavigationAgent3D encontrará o ponto mais próximo no NavMesh
	nav_agent.target_position = target_pos

func _physics_process(delta: float) -> void:
	return
	# 1. Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Navegação
	if nav_agent.is_navigation_finished():
		if timer.is_stopped():
			timer.start(randf_range(1.0, 3.0)) # Tempo de espera antes de ir para o próximo ponto
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()
		return

	# Calcula a direção para o próximo ponto do caminho
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	
	# Removemos a trava do direction.x = 0
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Lógica de rotação suave para olhar na direção do movimento
		if visual_node:
			var look_direction = Vector2(velocity.z, velocity.x) # Invertido para o sistema de coordenadas do Godot
			var target_angle = look_direction.angle()
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, target_angle, 0.1)
	
	move_and_slide()

# Quando o tempo de espera acaba, escolhe um novo destino
func _on_timer_timeout() -> void:
	setup_target()
