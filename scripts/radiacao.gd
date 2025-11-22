extends Area2D

# Certifique-se de que os @onready nodes estão corretos
@onready var collision: CollisionShape2D = $CollisionShape2D 
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D 

# 
func _on_body_entered(body: CharacterBody2D) -> void:
  
	if body is CharacterBody2D and body.has_method("die"):
		print("DEBUG: Player colidiu com Radiação. Causando dano...")
		
		body.die()
