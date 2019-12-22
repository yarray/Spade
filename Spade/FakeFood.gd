extends Node2D

signal destroyed
var space : TileMap
var pos = Vector2(0, 0)
var under_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(outer_space, spawn_pos, value):
	space = outer_space
	under_value = value
	pos = spawn_pos
	space.set_cellv(pos, 4)
	$Timer.start()

func _on_Timer_timeout():
	space.set_cellv(pos, under_value)
	emit_signal("destroyed")
