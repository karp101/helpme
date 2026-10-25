extends Control



func _on_start_pressed() -> void:
	get_node("/root/Rooms").startGame()


func _on_quit_pressed() -> void:
	get_tree().quit() 
