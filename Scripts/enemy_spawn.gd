extends Node2D

var enemyPath = [preload("res://Scenes/basic_enemy.tscn"), preload("res://Scenes/basic_enemy_2.tscn")];
var enemyAquired = [true, true];
var enemyWeights = [75, 25];

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemyInst = null;
	
	var weightSum = 0;
	var weights = [];
	var weightsID = [];

	
	for i in enemyWeights.size():
		if enemyAquired[i]:
			weightSum += enemyWeights[i];
			weights.push_back(enemyWeights[i]);
			weightsID.push_back(i);
			
	var rand = randi_range(0, weightSum);
	var sum = 0;
	
	for i in weights.size():
		sum += weights[i];
		if rand <= sum:
			enemyInst = enemyPath[weightsID[i]].instantiate();
			break;
	
	add_child(enemyInst);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
