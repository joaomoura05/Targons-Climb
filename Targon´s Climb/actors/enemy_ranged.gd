extends CharacterBody2D

@onready var state_timer = $StateTimer
@onready var attack_timer = $AttackTimer
@onready var player = $"../player/Hurtbox"
@onready var sword = $"../player/attack"

@onready var enemySprites = $Sprites
@onready var enemyHurtbox = $Hurtbox
@onready var enemyBody = $Body
@onready var enemyAttack = $Attack

var health = 100
var dead = false
var hurt = false
var speed = 100
var max_speed = 150
var target_position = 0;
var randomnum
var attacking = false
const distancia_maxima_player: int = 80
const distancia_minima_player: int = 40
var distancia_jogador: float

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	state_timer.start()
	

func _physics_process(delta):
	var inativo := (!dead and !hurt and !attacking)
	if inativo:
		enemySprites.play("walk")
	distancia_jogador = (player.position - global_position).length()
	if distancia_jogador > distancia_maxima_player:
		_get_path_to_player()
	elif distancia_jogador < distancia_minima_player:
		_get_path_to_move_away_from_player()
	else:
		aim_raycast.target_position = player.position - global_position
		if can_attack and state_machine.state == state_machine.states.idle and not aim_raycast.is_colliding():
			can_attack = false
			_throw_knife()
			attack_timer.start()


func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()
	
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	navigation_agent.target_position = global_position + dir * 100

	
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)

func _on_hurtbox_area_entered(area):
	if area == sword and dead == false:
		if !attacking:
			hurt = true
			enemySprites.play("hurt")
		health-=20
		if health <= 0:
			dead = true
			enemyBody.set_deferred("disabled",true)
			enemySprites.play("death")


func _on_sprites_animation_finished():
	if enemySprites.animation == "hurt":
		hurt = false
	if enemySprites.animation == "death":
		queue_free()
	if enemySprites.animation == "hit":
		attacking = false
		$Attack/left.set_deferred("disabled",true);
		$Attack/right.set_deferred("disabled",true);
		$Attack/up.set_deferred("disabled",true);
		$Attack/down.set_deferred("disabled",true);


func _on_hitbox_area_entered(area):
	if area == player:
		attack_timer.start()


func _on_attack_timer_timeout():
	if !dead:
		$Attack/left.set_deferred("disabled",false);
		$Attack/right.set_deferred("disabled",false);
		$Attack/up.set_deferred("disabled",false);
		$Attack/down.set_deferred("disabled",false);
		if !hurt:
			attacking = true
			enemySprites.play("hit")

func _on_state_timer_timeout():
	match state:
		SURROUND:
			state = ATTACK
		ATTACK:
			state = SURROUND
