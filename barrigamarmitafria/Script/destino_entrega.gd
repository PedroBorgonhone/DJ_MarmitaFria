extends Area2D

signal entrega_concluida

func _on_body_entered(body):
	if body.name == "barriga":
		print("Entrega Concluída! Próxima Fase...")
		
		entrega_concluida.emit()
		
		set_monitoring(false)
