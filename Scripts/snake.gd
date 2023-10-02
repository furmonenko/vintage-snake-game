extends Area2D

class_name Snake

@onready var movement_timer = $MovementTimer
@onready var tail_scene = preload("res://Scenes/tail.tscn")

var tail_array = []
var dir_array = []

var last_position :Vector2
var next_position :Vector2

var can_change_direction = true

signal snake_moved
signal game_lost

var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
			
var direction = Vector2.UP
var prev_direction : Vector2
var dir : Vector2

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	dir_array.append(Vector2.UP)
	
func _unhandled_input(event):
	prev_direction = direction
	
	# if can_change_direction:
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			direction = inputs[dir]
			if prev_direction == -direction:
				direction = prev_direction
			dir_array.append(direction)
			# can_change_direction = false

func move():
	if !dir_array.is_empty():
		dir = dir_array.front()

	global_position += dir * tile_size
	look_at(dir + global_position)
	emit_signal("snake_moved")
	
	dir_array.pop_front()
	
	# can_change_direction = true
	
func _on_movement_timer_timeout() -> void:
	move()

func get_next_position():
	next_position = position + direction * tile_size
	return next_position

func get_last_position():
	last_position = position
	return last_position

func _on_go_faster_timer_timeout() -> void:
	if movement_timer.wait_time >= 0.06:
		movement_timer.wait_time -= 0.008

func _on_body_entered(_body: Node2D) -> void:
	$"Hit Sound".play()
	emit_signal("game_lost")

func disable_movement():
	movement_timer.stop()
