extends CharacterBody2D


@onready var attack_timer = $AttackTimer
@onready var player = $"../player"
@onready var sword = $"../player/attack"
@onready var enemySprites = $AnimatedSprite2D
@onready var enemyHurtbox = $Hurtbox
@onready var enemyBody = $Body

var health = 100
var dead = false
var hurt = false
var speed = 100
var max_speed = 150
var target_position = 0;
var randomnum

enum {
	SURROUND,
	ATTACK,
	HIT,
}

var state = SURROUND

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()

func _physics_process(delta):
	if dead == false and hurt == false:
		enemySprites.play("walk")
		match state:
			SURROUND:
				move(get_circle_position(randomnum), delta)
			ATTACK:
				move(player.global_position, delta)
			HIT:
				move(player.global_position, delta)
				print("HIT")
				enemySprites.play("hit")

func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()
	
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)


func _on_AttackTimer_timeout():
	state = ATTACK

func _on_hurtbox_area_entered(area):
	if area == sword && dead == false:
		hurt = true
		enemySprites.play("hurt")
		health-=20
		if health <= 0:
			print("mateikkkkkk")
			dead = true
			enemyBody.set_deferred("disabled",true)
			enemySprites.play("death")


func _on_animated_sprite_2d_animation_finished():
	if enemySprites.animation == "hurt":
		hurt = false
	if enemySprites.animation == "death":
		queue_free()
