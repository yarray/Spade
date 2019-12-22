extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Snake.init($Space)
	$Space.init($Snake)

func _on_Space_food_eaten():
	score += 1
	$Score.set_text(str(score))
	
func _on_Snake_died():
	$Message.set_text("Game Over")
