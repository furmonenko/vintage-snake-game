extends Node2D

@onready var snake = $Snake
@onready var fruit = $Fruit
@onready var pickup_sound = $"Sound Effects/Pickup"
@onready var tail_scene = preload("res://Scenes/tail.tscn")
@onready var game_over_scene = preload("res://Scenes/game_over_scene.tscn")
@onready var save_path = "user://score.save"
@onready var hud = $UI/HUD

var save_file_path = "user://Save/"
var save_file_name = "SaveScore.tres"

@export var score_res :Score

var tail_array = []

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(save_file_path)
	
	if FileAccess.file_exists(save_file_path + save_file_name):
		score_res = ResourceLoader.load(save_file_path + save_file_name)
	else:
		score_res = Score.new()
		
	
	hud.set_score_res(score_res)
	increase_snake()
	
	fruit.connect("eaten_by_snake", _on_eaten_by_snake)
	snake.connect("snake_moved", _on_snake_moved)
	snake.connect("game_lost", _on_game_lost)
	score_res.connect("high_score_changed", _on_high_score_changed)
	
	score_res.score_init()
	hud.hud_init()
	
	tail_array[0].disable_collision()
	tail_array[0].position = snake.position

func _on_eaten_by_snake():
	pickup_sound.play()
	score_res.increase_score()
	increase_snake()

func _on_snake_moved() -> void:
	var last_snake_position = snake.get_last_position()
	tail_array[0].position = snake.get_next_position()

	for tail in tail_array:
		tail.global_position = last_snake_position
		last_snake_position = tail.global_position

func increase_snake():
	var new_tail = tail_scene.instantiate()
	new_tail.global_position = Vector2(-1000, -1000)
	tail_array.append(new_tail)
	call_deferred("add_child", new_tail)

func _on_game_lost():
	snake.disable_movement()
	
	for tail in tail_array:
		await get_tree().create_timer(0.1).timeout
		
		if tail != null:
			tail.queue_free()
			
	await get_tree().create_timer(0.5).timeout
	
	if hud:
		hud.visible = false
		
	var game_over_scene_instance = game_over_scene.instantiate()
	game_over_scene_instance.position = Vector2(128, 64)
	add_child(game_over_scene_instance)

func _on_high_score_changed():
	ResourceSaver.save(score_res, save_file_path + save_file_name)
