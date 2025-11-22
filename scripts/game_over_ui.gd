extends Control

var anim: AnimationPlayer

func _ready():
	pass
	
func show_screen():
	visible = true
	anim.play("appear")
	
	get_tree().paused = true

func _on_restartbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game.tscn")


func _on_quitbtn_pressed() -> void:
	get_tree().quit()
