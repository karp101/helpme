
extends Node2D

var potion = load("res://potion.tscn");

var choice1;
var choice2;
var choice3;

var chosen = false;

func _ready():
	Rooms.current_enemies = 1;
	choice1 = potion.instantiate();
	var notAquired = [];
	for i in AmmoType.ammoAquired.size():
		if !AmmoType.ammoAquired[i]:
			notAquired.push_back(i);
	choice1.typeID = notAquired[randi_range(0, notAquired.size() - 1)];
	choice1.choice = true;
	
	add_child(choice1);
	#get_node("Label").text = choice1.typeName;
	
	choice2 = potion.instantiate();
	notAquired = [];
	for i in AmmoType.ammoAquired.size():
		if !AmmoType.ammoAquired[i] && i != choice1.typeID:
			notAquired.push_back(i);
	choice2.typeID = notAquired[randi_range(0, notAquired.size() - 1)];
	choice2.choice = true;
	choice2.position.x -= 64;
	
	add_child(choice2);
	#get_node("Label2").text = choice2.typeName;
	
	choice3 = potion.instantiate();
	notAquired = [];
	for i in AmmoType.ammoAquired.size():
		if !AmmoType.ammoAquired[i] && i != choice1.typeID && i != choice2.typeID:
			notAquired.push_back(i);
	choice3.typeID = notAquired[randi_range(0, notAquired.size() - 1)];
	choice3.choice = true;
	choice3.position.x += 64;
	
	add_child(choice3);
	#get_node("Label3").text = choice3.typeName


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_child_exiting_tree(node):
	if !chosen:
		AmmoType.ammoAquired[node.typeID] = true;
		Rooms.updateEnemies();
		for i in get_children():
			i.queue_free();
		chosen = true;
