extends Control


func _on_return_pressed() -> void:
	get_node("/root/Game Manager").setup()
	self.queue_free()
