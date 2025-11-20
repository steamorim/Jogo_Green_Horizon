extends Control

func _ready():
	pass
	
func _process(delta):
	pass

func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
