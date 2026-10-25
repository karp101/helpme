extends CharacterBody2D

var angle = 0;
var speed = 0;
var typeID = 0
var typeName

var choice = false;

func _ready():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.set_frame_and_progress(typeID, typeID)
	angle = randf_range(0, 2 * PI);
	speed = randf_range(2, 10);
	if speed < 1 / 100:
		speed = 0;
	if typeID == 0:
		typeName = "Poison";
		#scale *= .5;
	if typeID == 1:
		typeName = "Red Poison";
		#scale *= .75;
	if typeID == 2:
		typeName = "Black Poison";
		#scale *= .25;
	if typeID == 3:
		typeName = "Heal";

func _physics_process(delta):
	#position.x += speed * cos(angle);
	#position.y += speed * sin(angle);
	speed *= .9
	#move_and_slide()
	if !choice:
		move_and_collide(Vector2(speed * cos(angle), speed * sin(angle)))

	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.ammo.size() < 9:
			body.ammo.push_back(typeName)
			queue_free()
