extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	
	#Rooms.startGame();
func setup():
	var menu = load("res://Scenes/Rooms/Menu.tscn").instantiate();
	add_child(menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
