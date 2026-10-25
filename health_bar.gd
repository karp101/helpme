extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	stop();
	set_frame_and_progress(10, 10);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var h = GlobalVars.playerHealth / 3;
	h += 5;
	h /= 10;
	h = floor(h);
	
	if h == 0:
		set_frame_and_progress(11, 11);
	else:
		set_frame_and_progress(h, h);
