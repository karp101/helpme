extends CharacterBody2D
@export var player: Node2D
@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D
const speed = 200
const bullet_speed = 500
var max_health = 0
var aim_attack = true
var health = 0
var alrHit = false
var statuses = []
var applying_dot = false
var dropAmount = 0;
var dropWeights = [];
var avoidance = 1
var nav 
var type
var state = "Idle"
var enemyList = []
var effects = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Rooms").addEnemies(self)
	if name == "Chest":
		health = 1;
		max_health = health
		dropAmount = 9;
		dropWeights = [5, 0, 0, 5];
		nav = false
		aim_attack = false
	if name == "BasicEnemy":
		health = 100.0;
		max_health = health
		dropAmount = 4;
		dropWeights = [4, 0, 0, 1];
		nav = true
		type = "Poison"
	if name == "BasicEnemy2":
		health = 200.0;
		max_health = health
		dropAmount = 6;
		dropWeights = [0, 3, 0, 2];
		nav = true
		type = "Red Poison"
	if name == "healer_enemy":
		health = 75.0
		max_health = health
		dropAmount = 6;
		dropWeights = [3, 0, 0, 2];
		nav = true
		type = "Heal"
	if name == "black_enemy":
		health = 150.0
		max_health = health
		dropAmount = 4;
		dropWeights = [0, 0, 4, 1];
		nav = true
		type = "Black Poison"
		#enemyList = get_node("/root/Rooms").enemyList
func make_path() -> void:
	if not self.is_queued_for_deletion() && player != null:
		
		nav_agent.target_position = player.global_position
	else:
		player = self

func _on_timer_timeout():
	make_path()
	



func _physics_process(delta: float) -> void:
	if nav:
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		
		velocity = (direction) * speed * avoidance
		if (nav_agent.distance_to_target() < 75 && nav_agent.distance_to_target() > 50):
			velocity = Vector2.ZERO
		position += velocity * delta
		move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nav:
		if player != null && state == "Idle":
			search_check()
	enemyList.clear()
	if type == "Heal":
		for a in $Sight.get_overlapping_bodies():
			if a.get_name() != "Chest" && a.is_in_group("Enemy"):
				enemyList.append(a)
	pass
	if (aim_attack) && player != null:
		$Line2D.set_point_position(1, to_local(player.position).limit_length(10.0))
		$Line2D.self_modulate.a =  255 * (3/($AttackTimer.get_time_left() + 1))
			 
	
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

		

		
func hit(ammo):
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
			health += AmmoType["ammo"][ammo]["Base Heal"] / 3
			
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
	
	if health > max_health:
		health = max_health
	elif health <= 0:
		var potion = load("res://potion.tscn");
		var potionInst;
		
		var weightSum = 0;
		for i in dropWeights.size():
			weightSum += dropWeights[i];
		
		var rand = randi_range(0, weightSum);
		var sum = 0;
		
		var drop = 0;
		for i in dropAmount:
			for ii in dropWeights.size():
				sum += dropWeights[ii];
				if rand <= sum:
					potionInst = potion.instantiate();
					potionInst.typeID = ii;
					
					get_parent().call_deferred("add_child",potionInst)
					potionInst.position = self.position
					break;
		await get_node("/root/Rooms").updateEnemies()
		queue_free()
	if (self.get_name() != "Chest"):
		$HPBar.value = (health / max_health) * 100.0
	
func _on_safe_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		avoidance = 0


func _on_safe_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		avoidance = 1


func _on_avoidance_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		avoidance = -1


func _on_avoidance_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		avoidance = 0

func _on_sight_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player" && state == "Idle" && player != null:
		search_check()


func search_check():
	var raycast = PhysicsRayQueryParameters2D.create(self.position, player.position, 1, [self]) # + Vector2(0,100)
	raycast.set_collide_with_bodies(true)
	var result = get_world_2d().direct_space_state.intersect_ray(raycast)
	if result:
		if result.collider.name == "Player":
			state = "Attack"
			$AttackTimer.start()
			$Timer.start()
			avoidance = 1

func _on_attack_timer_timeout() -> void:
	aim_attack = false
	await get_tree().create_timer(0.2, false).timeout
	aim_attack = true
	var bullet = load("res://Scenes/enemy_bullet.tscn").instantiate()
	"""if $Sprite2D.flip_h == true:
		arrow.position = self.position + Vector2(10,0)
	else:
		arrow.position = self.position - Vector2(10,0)"""
	bullet.connect("hit", on_bullet_hit)
	if get_node_or_null("Bullet1") == null:
		bullet.name = "Bullet1"
	bullet.fired_from = self.name
	bullet.speed = bullet_speed
	bullet.ammo = type
	if type == "Heal":
		bullet.look_at(to_local(determine_target()))
	else: 
		bullet.look_at(to_local(player.position))
	get_parent().add_child(bullet, true)
	bullet.position = self.position

func determine_target():
	for a in enemyList:
		print(a.get_name())
	if enemyList.size() <= 1:
		pass
	var enemy = enemyList.get(0)
	var HpCalc = enemy.health / enemy.max_health
	for e in enemyList:
		if e.get_name() != "Chest":
			var testCalc = e.health / e.max_health
			if testCalc < HpCalc && e != self:
				enemy = e
				HpCalc = e.health / e.max_health
	print("******")
	print(enemy.get_name())
	print(to_global(enemy.position))
	return enemy.position	
func on_bullet_hit(bullet):
	bullet.queue_free()

	
