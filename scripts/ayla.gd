extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var is_dead: bool = false


# -----------------------------
# FUNÇÃO DE MORTE DO JOGADOR
# -----------------------------
func die():
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	anim.play("dead")


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

	# Atribui a velocidade horizontal
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animação
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
	# Pegamos o nó do inimigo (pai da hurtbox dele)
	var enemy = area.get_parent()

	if velocity.y > 0:
		# Jogador está caindo -> mata o inimigo
		if enemy:
			enemy.queue_free()
		velocity.y = JUMP_VELOCITY * 0.6  # pequeno bounce
	else:
		# Jogador morre
		die()
