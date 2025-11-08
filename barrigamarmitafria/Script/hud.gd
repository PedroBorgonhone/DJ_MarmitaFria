extends CanvasLayer

@onready var timer = $Timer
@onready var time_label = $Label

# Dentro do seu script HUD.gd
func set_phase_time(new_time: int):
	$Timer.wait_time = new_time
	$Timer.start()
	time_left = new_time
	update_time_label()
	
var time_left: int = 0

func _ready():
	time_left = int(timer.wait_time)
	update_time_label()
	timer.start()
	
func _process(delta):
	var current_time = int(timer.time_left)

	if current_time != time_left:
		time_left = current_time
		update_time_label()

func update_time_label():
	time_label.text = "Tempo Restante: %s" % time_left

func _on_timer_timeout():
	print("TEMPO ESGOTADO! GAME OVER!") 
	time_label.text = "Tempo Esgotado!" 
	Engine.time_scale = 0.0
	
