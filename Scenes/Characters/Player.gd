extends CharacterBody2D


const SPEED = 500.0
const hpToPoison = 45
const bullet_speed = 2000
const reload = 0.6
const iFrameLength = 1.5
const swap_cd = 0.5
var attack_ready = true
var ammo = []
var reserve
var health = 300
var applying_dot = false
var statuses = []
var iFrames = false
var effects = []
var swap_ready = true

func _ready():
	health = 300
	check_health()

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		velocity.x += 1
		if !Input.is_action_pressed("left"):
			get_node("AnimatedSprite2D").scale.x = .3;
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		if !Input.is_action_pressed("right"):
			get_node("AnimatedSprite2D").scale.x = -.3;

	if Input.is_action_pressed("down"): # basic movement
		velocity.y += 1

	if Input.is_action_pressed("up"):
		velocity.y -= 1
	
	velocity = velocity.normalized()
	position += (velocity) * SPEED * delta  # add knockback here
	move_and_slide()
	"""
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	"""
	move_and_slide()
	var mouse_pos = get_viewport().get_mouse_position()

	
	$RayCast2D.target_position = to_local(mouse_pos)
	if $RayCast2D.get_collider(): 
		$Reticle.position = to_local($RayCast2D.get_collision_point())
		# gets blocked by bodies on collision layer 1
	else: # update reticle and trajectory 
		$Reticle.position = to_local(mouse_pos)
	$Trajectory.set_point_position(1, $Reticle.position) 
	
func _process(delta: float) -> void:
	GlobalVars.playerAmmo = ammo;
	
	if attack_ready:
		if Input.is_mouse_button_pressed(1):
			var mouse_pos = get_viewport().get_mouse_position()
			shoot(mouse_pos)
		elif Input.is_mouse_button_pressed(2) && ammo.size() != 0: # theres prob a way to combine these somehow
			inject()
			
func _input(event: InputEvent) -> void:
	if event.is_action("swap") && ammo.size() != 0 && swap_ready:
		update_reserve()

func hit(ammo):
	if not iFrames:
		damage(ammo)
		iFrames = true
	await get_tree().create_timer(iFrameLength, false).timeout
	iFrames = false
func shoot(mouse_pos):
	var ammo_type
	if ammo.size() == 0:
		health -= hpToPoison
		ammo_type = "Poison" #change later to match naming
		# summon bullet with type poison
	else: 
		ammo_type = ammo.pop_front()
	#print("Player: " + ammo_type)
	var bullet = load("res://Scenes/Characters/bullet.tscn").instantiate()
	"""if $Sprite2D.flip_h == true:
		arrow.position = self.position + Vector2(10,0)
	else:
		arrow.position = self.position - Vector2(10,0)"""
	bullet.connect("hit", on_bullet_hit)
	if get_node_or_null("Bullet1") == null:
		bullet.name = "Bullet1"
	
	
	bullet.speed = bullet_speed
	bullet.ammo = ammo_type
	bullet.look_at($Reticle.position)
	
	get_parent().add_child(bullet, true)
	bullet.position = self.global_position
	attack_ready = false
	await get_tree().create_timer(reload, false).timeout
	attack_ready = true

	

func inject():
	var ammo_type = ammo.pop_front()
	damage(ammo_type)
	attack_ready = false
	await get_tree().create_timer(reload, false).timeout
	attack_ready = true
	
func on_bullet_hit(bullet):
	bullet.queue_free()
	#print(ammo)
	#ammo.append("Black Poison")
	

func apply_dot(i):  #mostly same hit function as in enemies
	
	applying_dot = true
	
	while (statuses[i][1] > 0 && health > 0):
		if effects.has("Amplifier"):
			statuses[i][1] -= AmmoType["ammo"][statuses[i][0]]["Tick Rate"] / 2
			await get_tree().create_timer(AmmoType["ammo"][statuses[i][0]]["Tick Rate"] / 2, false).timeout
		else:
			await get_tree().create_timer(AmmoType["ammo"][statuses[i][0]]["Tick Rate"], false).timeout
			statuses[i][1] -= AmmoType["ammo"][statuses[i][0]]["Tick Rate"]
		if AmmoType["ammo"][statuses[i][0]].has("Heal Tick"):
			health += AmmoType["ammo"][statuses[i][0]]["Heal Tick"]
		elif !effects.has("Antidote"):
			health -= AmmoType["ammo"][statuses[i][0]]["Damage Tick"]
		else:
			statuses[i][1] = 0
		check_health()
	if (statuses.size() == 1):
		statuses.clear()
		applying_dot = false
	else:
		statuses.set(i, null)
		

		
func damage(ammo):
	
		var type = AmmoType["ammo"][ammo]["Type"]
		if type == "Status":
			health -= AmmoType["ammo"][ammo]["Base Damage"]
			check_health()
			
			var current_location = check_status(ammo)
			
			if current_location == -1:
				statuses.append([ammo, AmmoType["ammo"][ammo]["DOT Duration"]])
				apply_dot(statuses.size() - 1)
			else:
				statuses[current_location][1] = AmmoType["ammo"][ammo]["DOT Duration"]
			
			
			
		elif type == "Heal":
			health += AmmoType["ammo"][ammo]["Base Heal"]
			check_health()
		elif type == "Effect":
			effects.append(ammo)
			await get_tree().create_timer(AmmoType["ammo"][ammo]["Duration"]).timeout
			effects.erase(ammo)
			
func check_status(ammo):
	var i = 0 
	while i < statuses.size():
		if statuses[i] != null:
			if statuses[i][0] == ammo:
				return i
		i+=1
	return -1

func check_health():
	if health > 300:
		health = 300
	GlobalVars.playerHealth = health;
	
	if health <= 0:
		get_node("/root/Rooms").endGame()
		queue_free()

func update_reserve():
	var temp = ammo.front()
	if reserve == null:
		ammo.pop_front()
	else: 
		ammo.set(0, reserve)
	reserve = temp
	swap_ready = false
	await get_tree().create_timer(swap_cd, false).timeout
	swap_ready = true
