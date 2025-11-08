extends Area2D

func _on_body_entered(body):
	if body.name == "Barriga_Moto": 
		body.velocity.x = 0.0
		
	if body.has_method("reset_speed"):
		body.reset_speed()
		
	queue_free()
