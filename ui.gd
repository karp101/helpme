extends Control

#var ammoRects = [$ColorRect1, $ColorRect2, $ColorRect3, $ColorRect4, $ColorRect5, $ColorRect6, $ColorRect7, $ColorRect8, $ColorRect9]
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in GlobalVars.playerAmmo.size():
		if GlobalVars.playerAmmo[i] == "Poison":
			get_node("ColorRect" + str(i)).color = "843a89";
		if GlobalVars.playerAmmo[i] == "Heal":
			get_node("ColorRect" + str(i)).color = "548845";
			
	
	pass
