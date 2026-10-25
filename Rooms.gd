extends Node

var currentRoom = 0
var level = 0;
var current_enemies = 0
var enemyList = []

var roomPath = ["res://Scenes/Rooms/TestRoom.tscn", "res://Scenes/Rooms/room_2.tscn"];
var roomExitDirs = [[1, 2], [0, 3]];
var roomExitX = [[388, 160], [256, 16]];
var roomExitY = [[320, 464], [16, 224]];
var locked_door 
var current_player

func addEnemies(enemy):
	current_enemies += 1
	enemyList.append(enemy)
	
	
func updateEnemies():
	current_enemies -= 1
	if current_enemies == 0:
		if level == 10:
			winGame()
		enemyList.clear()
		for door in get_child(0).get_node("Doors").get_children():
			if door.get_name() != locked_door:
				door.open_door()
			

func newRoom(dir, body):
	current_enemies = 0
	enemyList.clear()
	level += 1;
	
	#New Direction
	dir += 2;
	if dir > 3:
		dir -= 4;
	
	var room;
	if level == 1 || level == 8:
		room = load("res://Scenes/Rooms/room_potion.tscn");
	elif level == 10:
		room = load("res://Scenes/Rooms/room_end.tscn");
	else:
		var posRooms = [];
		var posRoomsID = [];
		for i in roomExitDirs.size():
			for ii in roomExitDirs[i].size():
				if roomExitDirs[i][ii] == dir:
					posRoomsID.push_back(i);
					posRooms.push_back(roomPath[i]);
		
		var rand = randi_range(0, posRooms.size() - 1);
		currentRoom = posRoomsID[rand];
		room = load(posRooms[rand]);

	var roomInst = room.instantiate();
	call_deferred("add_child", roomInst)
	var roomName = roomInst.get_name() 


	get_child(0).remove_child(body)
	roomInst.call_deferred("add_child",body)
	
	current_player = body
	enemyNav.call_deferred()
	get_child(0).queue_free()
	
	
	var exitID = roomExitDirs[currentRoom].find(dir)
	body.position.x = roomExitX[currentRoom][exitID];
	body.position.y = roomExitY[currentRoom][exitID];
	var door = roomInst.get_node("Doors")
	if dir == 0:
		body.position.y += 50;
		locked_door = "DoorN"
	if dir == 1:
		body.position.x -= 50;
		locked_door = "DoorE"
	if dir == 2:
		body.position.y -= 50;
		locked_door = "DoorS"
	if dir == 3:
		body.position.x += 50;
		locked_door = "DoorW"
	print(locked_door)
	pass
	
func startGame():
	enemyList.clear()
	level = 0
	var room = load(roomPath[0]).instantiate();
	var player = load("res://Scenes/Characters/player.tscn").instantiate()
	current_enemies = 0
	add_child(room);
	room.add_child(player)
	get_node("/root/Game Manager/Menu").queue_free()
	current_player = player
	enemyNav()
	player.position = Vector2(180,300)
	player.scale *= 0.5
func winGame():
	get_child(0).queue_free()
	var win_screen = load("res://Scenes/Rooms/win.tscn").instantiate()
	add_child(win_screen)
func endGame():
	get_child(0).queue_free()
	var lose_screen = load("res://Scenes/Rooms/lose.tscn").instantiate()
	add_child(lose_screen)

func enemyNav():
	for enemy in enemyList:
		print(current_player)
		enemy.player = current_player
