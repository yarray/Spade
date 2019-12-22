extends TileMap

export var board_x: int
export var board_y: int
signal food_eaten
var fake_food_proto = preload("res://FakeFood.tscn")
var fake_foods = {}
var snake

func rand_select_pos(cond):
	var x = randi() % board_x
	var y = randi() % board_y
	while not cond.call_func(Vector2(x, y)):
		x = randi() % board_x
		y = randi() % board_y		
	return Vector2(x, y)

func no_value(val):
	for x in range(board_x):
		for y in range(board_y):
			if get_cell(x, y) == val and snake.head != Vector2(x, y) and not Vector2(x, y) in snake.body:
				return false
	return true
	
func collide_snake(v):
	if snake.head == v:
		return true
	for b in snake.body:
		if b == v:
			return true
	return false

func soil(v):
	return get_cellv(v) == 2

func sky(v):
	if collide_snake(v):
		return false
	return get_cellv(v) <= 1
	
func hole(v):
	if collide_snake(v):
		return false
	return get_cellv(v) == 3
	
func remove_food(f):
	remove_child(f)
	fake_foods.erase(f.pos)
	spawn_fake_food()
	
func spawn_at(v):
	var food = fake_food_proto.instance()
	fake_foods[v] = food
	food.connect("destroyed", self, "remove_food", [food])
	food.init(self, v, get_cellv(v))
	add_child(food)

func spawn_fake_food():
	var v: Vector2
	if randi() % 2 == 0 and not no_value(2):
		# spawn soil
		v = rand_select_pos(funcref(self, "soil"))
	else:
		# spawn sky
		v = rand_select_pos(funcref(self, "sky"))
	spawn_at(v)
	
func eat_fake(v):
	set_cellv(v, fake_foods[v].under_value)
	remove_food(fake_foods[v])
	# spawn real food
	if no_value(3):
		return
	var real_v = rand_select_pos(funcref(self, "hole"))
	set_cellv(real_v, 5)
	
func eat(v):
	set_cellv(v, 3)
	emit_signal("food_eaten")

func init(outer_snake):
	snake = outer_snake
	spawn_at(Vector2(20, 4))
	for i in range(3):
		spawn_fake_food()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
