extends StaticBody2D

var dir = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	if rotation_degrees == 0:
		dir = 0;
	if rotation_degrees == 90:
		dir = 1;
	if rotation_degrees == 180:
		dir = 2;
	if rotation_degrees == 20:
		dir = 3;
	
	#Rooms.roomExitDirs[Rooms.currentRoom].push_back(dir);
	#Rooms.roomExitX[Rooms.currentRoom].push_back(position.x);
	#Rooms.roomExitY[Rooms.currentRoom].push_back(position.y);
	#print(Rooms.roomExitY);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_door():
	$CollisionShape2D.set_deferred("disabled", true)
