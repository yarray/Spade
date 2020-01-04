extends TileMap

export var board_x: int
export var board_y: int
signal died
var init_pos = Vector2(20, 12)
var speed = 4
var speed_acc = 0
var direction = Vector2(1, 0)
var head = Vector2(init_pos.x, init_pos.y)
var body = [Vector2(init_pos.x - 1, init_pos.y), Vector2(init_pos.x - 2, init_pos.y)]
var space: TileMap
var digging = false
var growing = false

func render():
	clear()
	set_cellv(head, 1)
	for b in body:
		set_cellv(b, 0)
		
func affect():
	var val = space.get_cellv(head)
	if val <= 1:
		if digging:
			digging = false
	elif val == 2:
		space.set_cellv(head, 3)
		digging = true
	elif val == 3:
		if digging:
			emit_signal("died")
			set_process(false)
	elif val == 4:
		space.eat_fake(head)
	elif val == 5:
		space.eat(head)
		growing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	render()
	
func init(outer_space: TileMap):
	space = outer_space

func move():
	body.insert(0, head)
	if not growing:
		body.pop_back()
	else:
		growing = false
	head = (head + direction) 
	head.x = (int(head.x) + board_x) % board_x
	head.y = (int(head.y) + board_y) % board_y
	if head in body:
		emit_signal("died")
	render()

func input():
	var d = Vector2(0, 0)
	if Input.is_action_just_pressed("ui_left"):
		d = Vector2(-1, 0)
	elif Input.is_action_just_pressed("ui_right"):
		d = Vector2(1, 0)
	elif Input.is_action_just_pressed("ui_up"):
		d = Vector2(0, -1)
	elif Input.is_action_just_pressed("ui_down"):
		d = Vector2(0, 1)
	if d != Vector2(0, 0) and d + direction != Vector2(0, 0) and d - direction != Vector2(0, 0):
		direction = d
		move()
		affect()
		speed_acc = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input()
	speed_acc += speed * delta
	if speed_acc > 1:
		move()
		affect()
		speed_acc -= 1
		
