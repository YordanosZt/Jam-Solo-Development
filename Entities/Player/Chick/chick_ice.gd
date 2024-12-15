extends Node2D


func play_anim() -> void:
	$AnimationPlayer.play("spawn")

func die() -> void:
	queue_free()
