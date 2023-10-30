extends CharacterBody2D

var dead = false
var speed = 25
var player = null

func _process(delta):
	if dead == false:
		$AnimatedSprite2D.play("walk_down")
		$AnimatedSprite2D.frame = 0

func _on_hurtbox_area_entered(area):
	print("mateikkkkkk")
	$AnimatedSprite2D.play("death")
	dead = true


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		queue_free()
