extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var is_dead: bool = false
var origin_position: Vector2
var lives: int = 3   # ← Três vidas

func _ready():
	# Salva a posição inicial do jogador
	origin_position = global_position

# -----------------------------
# FUNÇÃO DE MORTE DO JOGADOR
# -----------------------------
func die():
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	anim.play("dead")
	
	# Timer curto para animação de morte
	await get_tree().create_timer(0.4).timeout

	# Remove uma vida
	lives -= 1
	print("Vidas restantes: ", lives)

	if lives > 0:
		# Volta ao início
		global_position = origin_position
		velocity = Vector2.ZERO
		is_dead = false
		anim.play("idle")
	else:
		# Game Over
		print("Chamando GameOver...")
		game_over()

# -----------------------------
# GAME OVER
# -----------------------------
func game_over():
	print("GAME OVER!")

	# Trava o jogador
	is_dead = true
	velocity = Vector2.ZERO

	# Obtém o CanvasLayer (crie um na cena principal e chame de "UILayer")
	var ui_layer = get_tree().current_scene.get_node("UILayer")

	# Checa se já existe uma instância do Game Over
	var game_over_instance = ui_layer.get_node_or_null("GameOverUI")
	if not game_over_instance:
		# Carrega e instancia a cena de Game Over
		var game_over_scene = preload("res://entities/game_over.tscn")
		game_over_instance = game_over_scene.instantiate()
		game_over_instance.name = "GameOverUI"
		ui_layer.add_child(game_over_instance)

		# Configura para ocupar a tela inteira se for Control
		if game_over_instance is Control:
			game_over_instance.rect_size = get_viewport().get_visible_rect().size
			game_over_instance.rect_position = Vector2.ZERO
			game_over_instance.visible = false  # começa invisível

	# Ativa a tela de Game Over
	game_over_instance.visible = true

# -----------------------------
# LOOP PRINCIPAL
# -----------------------------
func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_update_animation(direction)
	move_and_slide()

# -----------------------------
# SISTEMA DE ANIMAÇÃO
# -----------------------------
func _update_animation(direction: float) -> void:
	if direction > 0:
		anim.flip_h = true
		anim.play("lado")
	elif direction < 0:
		anim.flip_h = false
		anim.play("lado")
	else:
		anim.play("idle")

# -----------------------------
# COLISÃO COM INIMIGO (HITBOX)
# -----------------------------
func _on_hitbox_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()

	if velocity.y > 0:
		# jogador caiu no inimigo → mata o inimigo
		if enemy:
			enemy.queue_free()
		velocity.y = JUMP_VELOCITY * 0.6  # bounce
	else:
		# jogador tocou no inimigo → morre
		die()
