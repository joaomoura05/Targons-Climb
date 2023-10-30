extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

const max_speed = 150
const accel = 750
const friction = 800
var attack_dir = ""
var input = Vector2.ZERO
var attacking:= false;

func _physics_process(delta):
	player_movement(delta)

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
		if attack_dir == "left":
			$attack/left.disabled = true;
		if attack_dir == "right":
			$attack/right.disabled = true;
		if attack_dir == "up":
			$attack/up.disabled = true;
		if attack_dir == "down":
			$attack/down.disabled = true;
	


func _on_hurtbox_area_entered(area):
	print("morrikkkkk")
