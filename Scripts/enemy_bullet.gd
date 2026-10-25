extends Area2D
var speed 
var ammo
var fired_from
signal hit


# Called when the node enters the scene tree for the first time.
func _ready():
	if (ammo == "Poison"):
		$ColorRect.color = "843a89"
	if (ammo == "Heal"):
		$ColorRect.color = "548845"
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	speed /= drag
#	drag = drag * drag_multi
#	drag_multi += (drag_multi * drag_multi) / 1000
#	if speed <= 250:
#		hit.emit(self)
	pass
func _physics_process(delta):

	position += transform.x * speed * delta

func _on_body_entered(body):  
	
	if (body.name != fired_from):
		if (body.name == "BasicEnemy" || body.name == "BasicEnemy2" || body.name == "Chest" || body.name == "Player"):
			body.hit(ammo)
		hit.emit(self)


func _on_area_entered(area):
	#print("AREAAA")
	#print(area.get_name())
		hit.emit(self)
		
#	if body.get_name() == "Player" || body.get_name() == "wall":
#		await get_tree().create_timer(0.5, false).timeout
#		hit.emit(body, self)


func _on_timer_timeout() -> void:
	hit.emit(self)
