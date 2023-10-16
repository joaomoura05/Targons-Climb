extends Node2D

@onready var anim = $player/AnimatedSprite2D


func _ready():
	anim.play("left")
