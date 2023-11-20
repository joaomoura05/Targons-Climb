extends CharacterBody2D

@onready var anim = $Sprites
@onready var enemy = $"../enemy/Attack"
@onready var body = $Body

const max_speed = 150
const accel = 750
const friction = 800
var attack_dir = ""
var input = Vector2.ZERO
var attacking:= false
var hurt = false
var health = 100
var dead = false

func _physics_process(delta):
	if dead == false:
		player_movement(delta)
	update_healthbar()

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if !attacking:
		if input.y > 0:
			anim.play("walk_down")
		elif input.y < 0:
			anim.play("walk_up")
		elif input.x > 0:
			anim.play("walk_right")
		elif input.x < 0:
			anim.play("walk_left")	
		else:
			anim.animation = (anim.animation.replace("walk","stop"))
			anim.play(anim.animation.replace("hit","stop"))
		
	return input.normalized()

func player_movement(delta):
	
	input = get_input()
	
	if Input.is_action_just_pressed("ui_hit"):
		attack()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)

	move_and_slide()
	
	
func attack():
	attacking = true
	anim.animation = (anim.animation.replace("walk","hit"))
	anim.play(anim.animation.replace("stop","hit"))
	attack_dir = anim.animation.replace("hit_","")
	if attack_dir == "left":
		$attack/left.disabled = false;
	if attack_dir == "right":
		$attack/right.disabled = false;
	if attack_dir == "up":
		$attack/up.disabled = false;
	if attack_dir == "down":
		$attack/down.disabled = false;

func _on_animated_sprite_2d_animation_finished():
	if anim.animation.contains("hit"):
		attacking = false
		$attack/left.disabled = true;
		$attack/right.disabled = true;
		$attack/up.disabled = true;
		$attack/down.disabled = true;
	
	if anim.animation == "hurt" && !dead:
		hurt = false
		attacking = false
		anim.play("stop_down")
	


func _on_hurtbox_area_entered(area):
	if area != null and enemy != null:
		if area.name == enemy.name && dead == false:
			hurt = true
			anim.play("hurt")
			health-=20
			if health <= 0:
				if dead == false:
					print("uma vez so ne")
					anim.play("hurt")
				dead = true
				body.set_deferred("disabled",true)

func update_healthbar():
	var healthbar = $Health/HealthBar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 100:
		health+=5
	if health > 100:
		health = 100
	if health <= 0:
		health = 0
