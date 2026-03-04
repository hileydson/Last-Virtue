extends CharacterBody3D

const SPEED_WALK = 3.0
const SPEED_RUN = 7.0
const JUMP_VELOCITY = 4.5

@onready var animation_tree = $Lady_Caracter/AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
# Certifique-se de que o seu modelo 3D está dentro de um Node3D chamado "Visual"
@onready var visual_node = $Lady_Caracter

func _physics_process(delta: float) -> void:
	
	# 1. Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and playback.get_current_node() != "jump":
		velocity.y = JUMP_VELOCITY
		playback.travel("jump")
		
	#corta animacao de jump ao chegar ao chao
	if  is_on_floor() and (playback.get_current_node() == "jump" or playback.get_current_node() == "attack_1"):
		playback.travel("idle")
		
	#corta a animacao de jump para chamar attack
	#if playback.get_current_node() == "jump" and Input.is_action_just_pressed("ui_attack_1"):

	# 3. Ataque
	if Input.is_action_just_pressed("ui_attack_1"):
		playback.travel("attack_1")

	# 4. Movimento Lateral (Eixo Z)
	var input_dir := Input.get_axis("ui_left", "ui_right")
	var current_speed = SPEED_RUN if Input.is_action_pressed("ui_run") else SPEED_WALK
	
	if input_dir != 0:
		velocity.z = input_dir * current_speed
		
		# Animações
		if playback.get_current_node() != "jump":
			if Input.is_action_pressed("ui_run"):
				if playback.get_current_node() != "run": playback.travel("run")
			else:
				playback.travel("walk")
			
		# --- LÓGICA DE VIRAR ---
		# Se input_dir for 1 (Direita/Z+), o ângulo é 0
		# Se input_dir for -1 (Esquerda/Z-), o ângulo é PI (180 graus)
		var target_rotation = 0.0 if input_dir > 0 else PI
		
		if visual_node:
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, target_rotation, 0.2)
			
	else:
		velocity.z = move_toward(velocity.z, 0, current_speed)
		if playback.get_current_node() != "attack_1" and playback.get_current_node() != "jump" and playback.get_current_node() != "idle":
			playback.travel("idle")

	# Trava o eixo X e a rotação do nó pai (Câmera)
	velocity.x = 0
	rotation.y = 0 
	
	move_and_slide()
