extends CharacterBody2D

var velocidade_atual = 300.0
const VELOCIDADE_INICIAL = 300.0
const VELOCIDADE_MAX = 600.0

const TAXA_AUMENTO_VELOCIDADE = 50.0

@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var desaceleration = 0.1

const VELOCIDADE_Y = 300.0

func _process(delta):
	velocidade_atual = move_toward(velocidade_atual, VELOCIDADE_MAX, TAXA_AUMENTO_VELOCIDADE * delta)

func _physics_process(delta):	
	var direcao_x = Input.get_axis("esquerda", "direita")
	var direcao_y = Input.get_axis("acima", "abaixo")
	
	if direcao_x:
		velocity.x = move_toward(velocity.x, direcao_x * velocidade_atual, velocidade_atual * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0.0, velocidade_atual * desaceleration)
		
	velocity.y = direcao_y * VELOCIDADE_Y
	
	var colisao = move_and_slide()
	
	if colisao:
		velocity.x = 0.0
		
func reset_speed():
	velocidade_atual = 100.0
