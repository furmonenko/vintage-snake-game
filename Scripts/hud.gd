extends Control

@onready var score_label = $Score
@onready var high_score_label = $"High Score"

@export var score_res : Score

func hud_init():
	print("hud ready")
	score_res.connect("score_increased", _on_score_increased)
	set_score(score_res.score)
	set_high_score(score_res.high_score)

func set_score(new_score :int):
	score_label.text = "Score: " + str(new_score)

func set_high_score(new_score :int):
	high_score_label.text = "High Score: " + str(new_score)

func _on_score_increased():
	set_score(score_res.score)
	set_high_score(score_res.high_score)

func set_score_res(new_score_res : Score):
	score_res = new_score_res
