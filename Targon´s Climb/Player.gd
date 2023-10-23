extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var anim_attack = $attack/CollisionShape2D

const max_speed = 150
const accel = 750
const friction = 700

var input = Vector2.ZERO

func _physics_process(delta):
	player_movement(delta)
	

func get_input():
	
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if input.y > 0:
		anim.play("walk_down")
	elif input.y < 0:
		anim.play("walk_up")
	elif input.x > 0:
		anim.play("walk_right")
	elif input.x < 0:
		anim.play("walk_left")	
	else:
		anim.play(anim.animation.replace("walk","stop"))
	
	return input.normalized()

func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
	move_and_slide()
	

	

