extends CharacterBody2D

# Velocidade de movimento
const SPEED = 200.0 

# O '_physics_process' roda a cada quadro de física e é ideal para movimento
func _physics_process(delta):
	# 1. Captura a entrada do jogador (teclas de direção/WASD)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# 2. Aplica a direção à variável 'velocity'
	if direction:
		velocity = direction * SPEED
	else:
		# Se nenhuma tecla for pressionada, o personagem para
		velocity = velocity.move_toward(Vector2.ZERO, 50) # Adiciona um pouco de desaceleração

	# 3. Move o corpo e trata a colisão
	move_and_slide()
