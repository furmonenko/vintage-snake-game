extends Area2D

class_name Fruit

signal eaten_by_snake

@onready var eaten_sound = $AudioStreamPlayer2D

var tile_size = 16

func _ready() -> void:
	fruit_init()

func fruit_init():
	global_position = rand_position()
	global_position = global_position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _on_area_entered(area: Area2D) -> void:
	if area is Snake:
		# eaten_sound.play()
		emit_signal("eaten_by_snake")
		fruit_init()
	
func rand_position():
	return Vector2(randi_range(16, 256 - 16), randi_range(16, 128 - 16))

func _on_body_entered(_body: Node2D) -> void:
	fruit_init()
