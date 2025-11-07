extends Node

const FASE_FACIL = preload("res://main.tscn")
# const FASE_MEDIA = preload("res://Fase_Media.tscn") # Crie este arquivo depois
# const FASE_DIFICIL = preload("res://Fase_Dificil.tscn") # Crie este arquivo depois

# Array com as cenas das fases (em ordem)
const FASES = [FASE_FACIL] # Adicione FASE_MEDIA e FASE_DIFICIL aqui

var current_phase_index = 0
var current_phase_node = null

# Referências a outros nós na cena Game.tscn
@onready var hud = $main/hud
@onready var player = $main/barriga
@onready var first_phase_node = $main # Referencia o nó 'main' que já está na cena
@onready var phase_times = {0: 120, 1: 90, 2: 60} # Tempo em segundos para cada fase (Fácil: 120s)


func _ready():
	current_phase_node = first_phase_node
	setup_phase() # Chama uma nova função para configurar a fase
	
func setup_phase():
	var destino_node = current_phase_node.get_node("destino_entreg")
	
	if destino_node:
		if not destino_node.entrega_concluida.is_connected(_on_phase_completed):
			destino_node.entrega_concluida.connect(_on_phase_completed)
		
		if not hud.get_node("Timer").timeout.is_connected(_on_game_over):
			hud.get_node("Timer").timeout.connect(_on_game_over)
		hud.set_phase_time(phase_times[current_phase_index])
	else:
		print("ERRO: Nó 'destino_entreg' não encontrado dentro da fase!")


# ----------------------------------------------------
# LÓGICA DE CARREGAMENTO
# ----------------------------------------------------

func load_phase(index):
	if index >= FASES.size():
		# Venceu o jogo!
		game_victory()
		return

	# Limpa a fase anterior (se houver)
	if current_phase_node:
		current_phase_node.queue_free()

	# 1. Instancia a nova fase
	var phase_scene = FASES[index]
	current_phase_node = phase_scene.instantiate()
	add_child(current_phase_node)

	# 2. Conecta os Sinais
	# A. Conecta a vitória (Meta)
	# Procuramos o nó DestinoEntrega dentro da cena da fase:
	current_phase_node.get_node("DestinoEntrega").entrega_concluida.connect(_on_phase_completed)

	# B. Conecta a derrota (Cronômetro)
	hud.get_node("Timer").timeout.connect(_on_game_over)

	# 3. Inicia o Cronômetro do HUD com o tempo certo
	hud.set_phase_time(phase_times[index])


# ----------------------------------------------------
# LÓGICA DE FIM DE JOGO
# ----------------------------------------------------

# Chamado quando o jogador chega no DestinoEntrega
func _on_phase_completed():
	print("Fase Concluída!")
	current_phase_index += 1
	
	# Pausa antes de carregar a próxima
	await get_tree().create_timer(2.0).timeout 
	load_phase(current_phase_index)


# Chamado quando o Timer do HUD chega a zero
func _on_game_over():
	print("GAME OVER - Tempo Esgotado!")
	# Desabilita o movimento do jogador (se não tiver feito isso no HUD.gd)
	player.set_process(false)
	# TODO: Mostrar tela de Game Over.
	get_tree().paused = true


func game_victory():
	print("PARABÉNS! VOCÊ ENTREGOU TODAS AS MARMITAS!")
	# TODO: Mostrar tela de vitória.
	get_tree().paused = true
