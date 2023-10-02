extends AnimatableBody2D

class_name Tail

func disable_collision():
	$CollisionShape2D.disabled = true

func enable_collision():
	$CollisionShape2D.disabled = false
