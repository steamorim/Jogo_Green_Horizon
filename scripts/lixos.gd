extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	# 1. Verifica se o corpo que entrou é o Player
	# Você pode usar body.is_in_group("player") se você adicionou o player a um grupo.
	# Como o seu Player usa a função 'collect_trash', podemos verificar isso:
	if body is CharacterBody2D and body.has_method("collect_trash"):
		
		# 2. Chama a função do Player para aumentar a contagem
		body.collect_trash()
		
		# 3. Remove o item do jogo
		queue_free()
