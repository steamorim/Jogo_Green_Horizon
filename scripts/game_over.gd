extends Control

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restartbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game.tscn")

func _on_quitbtn_pressed() -> void:
	get_tree().quit()
