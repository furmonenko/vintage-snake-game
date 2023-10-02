extends Resource

class_name Score

@export var high_score :int

signal score_increased
signal high_score_changed

var score = 0

func score_init():
	score = 0

func increase_score():
	score += 10
	
	if score >= high_score:
		high_score = score
		emit_signal("high_score_changed")
		
	emit_signal("score_increased")
