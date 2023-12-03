extends Area2D


var entered = false

func _on_body_entered(body: PhysicsBody2D):
	entered = true
	
func _process(delta):
	if entered == true:
		get_tree().change_scene_to_file("res://Levels/Level III.tscn")

